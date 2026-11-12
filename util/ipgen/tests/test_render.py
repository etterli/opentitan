# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

# Not overly pretty approach to find ipgen dependencies in the right directory.
# Remove once we are properly packaging our Python code.
import os
import sys

sys.path.append(os.path.join(os.path.dirname(__file__), '../../'))

import pytest  # noqa: E402
from ipgen import (IpBlockRenderer, IpConfig, IpTemplate,  # noqa: E402
                   TemplateRenderError)
from ipgen.lib import TemplateParams  # noqa: E402
from reggen.params import BaseParam  # noqa: E402


@pytest.fixture
def rendertest_dirs(tmp_path) -> None:
    """ Produce a simple IP template for render testing.

    Returns a tuple (template_directory, output_directory), expects the template
    to be rendered into output_directory, and checks that the minimal expected
    directory contents are present there.
    """
    template_dir = tmp_path / 'template'
    template_dir.mkdir()
    data_dir = template_dir / 'data'
    data_dir.mkdir()
    RENDERTEST_HJSON = """
{
  name: "rendertest"
  clocking: [
    {clock: "clk_i", reset: "rst_ni", idle: "idle_o", primary: true},
  ]
  bus_interfaces: [
    { protocol: "tlul", direction: "device" }
  ],
  registers: []
}
"""
    (data_dir / 'rendertest.hjson').write_text(RENDERTEST_HJSON)

    out_dir = tmp_path / 'out'

    yield (template_dir, out_dir)

    # Check that the basic structure of the IP template directory is retained.
    actual = set(str(p.relative_to(out_dir)) for p in out_dir.rglob('*'))
    exp = set([
        'rtl',
        'rtl/rendertest_reg_top.sv',
        'rtl/rendertest_reg_pkg.sv',
        'data',
        'data/inst_rendertest.ipconfig.hjson',
        'data/rendertest.hjson',
    ])
    assert exp.issubset(actual)


def test_render_simpleparam(rendertest_dirs) -> None:
    """ Test the IpBlockRenderer when it gets passed simple parameters. """

    (template_dir, out_dir) = rendertest_dirs

    (template_dir / 'test.txt.tpl').write_text('param1=${param1}')

    # Declare the template parameters.
    params = TemplateParams()
    params.add(BaseParam(name='param1', desc=None, param_type='string'))

    ip_template = IpTemplate('rendertest', params, template_dir)

    param_values = {
        'param1': 'somevalue',
    }

    ip_config = IpConfig(ip_template.params, 'inst_rendertest', param_values)

    # Render into the output directory.
    renderer = IpBlockRenderer(ip_template, ip_config)
    renderer.render(out_dir, overwrite_output_dir=False)

    # Check that the template parameters are rendered correctly.
    assert (out_dir / 'test.txt').is_file()
    assert (out_dir / 'test.txt').read_text() == 'param1=somevalue'


def test_render_objectparam(rendertest_dirs) -> None:
    """ Test the IpBlockRenderer when it gets passed object parameters. """

    (template_dir, out_dir) = rendertest_dirs

    template = """${obj['super']}
${obj['mega']}
% for item in obj['list']:
${item}
% endfor
"""
    (template_dir / 'test.txt.tpl').write_text(template)

    # Declare the template parameters.
    params = TemplateParams()
    params.add(BaseParam(name='obj', desc=None, param_type='object'))

    ip_template = IpTemplate('rendertest', params, template_dir)

    param_values = {
        'obj': {
            'super': 'duper',
            'mega': 1e6,
            'list': ['of', 'things'],
        },
    }

    ip_config = IpConfig(ip_template.params, 'inst_rendertest', param_values)

    # Render into the output directory.
    renderer = IpBlockRenderer(ip_template, ip_config)
    renderer.render(out_dir, overwrite_output_dir=False)

    # Check that the template parameters are rendered correctly.
    assert (out_dir / 'test.txt').is_file()
    assert (out_dir / 'test.txt').read_text() == 'duper\n1000000\nof\nthings\n'


def _render_error(tmp_path, template: str) -> str:
    """Render a template that is expected to fail and return the error message."""
    template_dir = tmp_path / 'template'
    template_dir.mkdir()
    (template_dir / 'test.txt.tpl').write_text(template)

    ip_template = IpTemplate('rendertest', TemplateParams(), template_dir)
    ip_config = IpConfig(ip_template.params, 'inst_rendertest', {})
    renderer = IpBlockRenderer(ip_template, ip_config)
    with pytest.raises(TemplateRenderError) as excinfo:
        renderer.render(tmp_path / 'out', overwrite_output_dir=False)
    return excinfo.value.verbose_str()


def test_render_assertion(tmp_path) -> None:
    """ A failing assertion is reported with the template name and location only. """

    msg = _render_error(tmp_path, 'text\n<% assert 1 == 2, "one is not two" %>\n')

    tpl_path = (tmp_path / 'template' / 'test.txt.tpl').resolve()
    assert msg == f"rendertest: one is not two ({tpl_path}:2)"


def test_render_param_errors(tmp_path, monkeypatch) -> None:
    """ Errors collected with ParamErrors are reported together, each with its location. """

    checks_dir = tmp_path / 'checks'
    checks_dir.mkdir()
    (checks_dir / 'rendertest_checks.py').write_text("""\
from ipgen.lib import ParamErrors


def check():
    errors = ParamErrors()
    errors.add("first error")
    errors.add("second error")
    errors.raise_errors()
""")
    monkeypatch.syspath_prepend(checks_dir)

    msg = _render_error(tmp_path, '<%! import rendertest_checks %>\n'
                                  '<% rendertest_checks.check() %>\n')

    checks_path = (checks_dir / 'rendertest_checks.py').resolve()
    assert msg == (f"rendertest: first error ({checks_path}:6)\n"
                   f"rendertest: second error ({checks_path}:7)")
