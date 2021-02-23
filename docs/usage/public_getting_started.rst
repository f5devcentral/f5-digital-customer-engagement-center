Getting started - Public access
------------------------------------------

In order to maintain a consistent deployment environemnt the solutions should all be deployed from the project provided container
the container will run locally on your machine, it inculdes the automation tools required to run the soltuions.
most of the solutions are using terraform to create the cloud componenets that are required, the container also maintain the terraform state files.


.. NOTE:: The following instructions will create a volume on your docker host and will instruct you
          to store private information in the host volume. the information in the volume will persist
          on the host even after the container is terminated.


.. NOTE:: it is your responsability to properly maintain any private/sensitive information used when deploying the solutions
          those sensitive items can include ssh keys , cloud credentials and passwords.


0.  Requirements


Here are the requirements for deploying solutions from this project:

0.1 Windows requirements
    - vscode https://code.visualstudio.com/
    - ms-vscode-remote.vscode-remote-extensionpack https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
    - docker https://www.docker.com/
    - wsl2 https://docs.microsoft.com/en-us/windows/wsl/
0.2 MacOs requirements
    - vscode https://code.visualstudio.com/
    - ms-vscode-remote.vscode-remote-extensionpack https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
    - docker https://www.docker.com/

1.  Clone the repo

    .. code-block::

    git clone https://github.com/f5devcentral/f5-digital-customer-engagement-center.git

2.  Open the repo in visual studio code


- Open visual studio code
- :guilabel:`file` --> :guilabel:`folder` --> choose the f5-digital-customer-engagement-center folder (where you cloned the repo to)


3.  Start the dev container

- open vscode command pallet :guilabel:`view` --> :guilabel:`command pallet`
- Type Remote-Containers: :guilabel:`Rebuild and Reopen in Container`

4. Open the dev container terminal

- in visual studio code click on the :guilabel:`terminal tab`

5. Start a solution!


.. toctree::
   :maxdepth: 1
   :caption: Solutions
   :glob:

   /docs/solutions/*/*_index
