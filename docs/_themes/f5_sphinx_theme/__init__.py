# Copyright 2017-2018 F5 Networks
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from os import path

__version__ = "1.0.9"

def get_html_theme_path():
    """Return the html theme path for this template library.

    :returns: List of directories to find template files in
    """
    curdir = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))
    return [curdir]

def setup(app):
    """Set up the theme for distribution as a python package

    :return: Adds f5-sphinx-theme to the html_themes path in Sphinx
    """
    app.add_html_theme('f5_sphinx_theme', path.abspath(path.dirname(__file__)))
