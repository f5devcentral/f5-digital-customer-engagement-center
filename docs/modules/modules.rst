*******
Modules
*******

Modules are chunks of reusable code created because external options did not exist or fit the need. In the context of DCEC, a module is a reference to a `Terraform module`_.  Modules are created, so solution creators do not need to recreate basic, underlining configurations. Instead, solution creators can focus on building solutions and reference these best practice modules.

Module ownership and creation are much like solution owners. There is a single code owner. That person is responsible for building best practices in a standard way.

Most module code will not have guided documentation, as it is pure Terraform. However, they are first-class object types for the project under the `modules`_ folder.

.. _`Terraform module`: https://www.terraform.io/docs/language/modules/develop/index.html
.. _`modules`: https://github.com/f5devcentral/f5-digital-customer-engagement-center/tree/main/modules
