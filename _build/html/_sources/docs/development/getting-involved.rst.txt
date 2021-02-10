How to get involved
===================

Thank you for getting involved with this project.

You can contribute in a number of different ways.

Here is some information that can help set your expectations.


Developing and supporting your module
-------------------------------------

When you develop a module, it goes through review before F5 accepts it. This review process may be difficult at times, but it ensures the published modules are good quality.

You should *stay up to date* with this site's documentation about module development. As time goes on, things change and F5 and the industry adopt new practices; F5 tries to keep the documentation updated to reflect these changes.

If you develop a module that uses an out-of-date convention, F5 will let you know, and you should take the initiative to fix it.

What to work on
---------------

While module/solution development is the primary focus of most contributors, it's understandable that you may not know how to create modules, or may not have any interest in creating modules to begin with.

That's OK. Here are some things you can do to assist.

Documentation
`````````````

Documentation help is always needed. F5 encourages you to submit documentation improvements.

Unit tests
``````````

The unit tests in the `test/` directory can always use work. Unit tests run fast and are not a burden on the test runner.

F5 encourages you to add more test cases for your particular usage scenarios or any other scenarios that are missing tests.

F5 adds enough unit tests to be reasonably comfortable that the code will execute correctly. This, unfortunately, does not cover many of the functional test cases. Writing unit test versions of functional tests is hugely beneficial.

New modules
```````````

Modules do not cover all of the ways you might use F5 products. If you find that a module is missing from the repo and you think F5 should add it, put those ideas on the Github Issues page.

New functionality for an existing module
````````````````````````````````````````

If a module is missing a parameter that you think it should have, raise the issue and F5 will consider it.

Postman collections
```````````````````

The Ansible modules make use of the F5 Python SDK. In the SDK, all work is via the product REST APIs. This just happens to fit in perfectly with the Postman tool.

If you want to work on new modules without involving yourself in ansible, a great way to start is to write Postman collections for the APIs that configure BIG-IP.

If you provide F5 with the Postman collections, F5 can easily write the module itself.

And you get bonus points for collections that address differences in APIs between versions of BIG-IP.

Bugs
````

Using the modules is the best way to iron out bugs. Using the modules in the way that **you** expect them to work is a great way to find bugs.

During the development process, F5 writes tests with specific user personas in mind. Your usage patterns may not reflect those personas.

Using the modules is the best way to get good code and documentation. If the documentation isn't clear to you, it's probably not clear to others.

Righting those wrongs helps you and future users.


