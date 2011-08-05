Using GIT - Modifying the code
******************************

Getting the code
================

Fork YProximite on GITHub
-------------------------

1. If you have not already an account on *GITHub*, create one.
2. Goto github.com/ylly and **fork** the **yProx** repository.

You now have your own version of *yProx* on your github account this is the version you will work with.

You will be push to the `ylly/master` repository using the *pull request* feature. More on this later.

Clone on your local machine
---------------------------

To clone locally::

    git clone git@gitub.com:youruser/yProx

And now add a new origin for the `Ylly` master repository::

    git remote add ylly git@github.com:ylly/yProx.git

This is required for pulling changes from the main repository back
to your local repository.

Working on tickets -- branching and commit formatting
-----------------------------------------------------

You should work on each Issue in isolation from anyother changes to the code base.

1. Which issue are you working on? *Issue 1183*? Good.
2. Checkout the master branch
3. Ensure that the master branch is in the last *stable* state.
4. Create a branch for *Issue 1183*::

    git branch issue-1183

5. Do the work required by *Issue 1183*.
6. Commit your changes
    1. Review your changes and stage them for commit using the command line or graphical tool of your choice, command line as follows::
        
        git status

    2. Note the section **changes staged for commit**. You will need to stage the files you have changed for commit using `git add`::

        git add foobar

    3. Commit your changes::

        git commit

    4. Enter the commit message, this should be formatted as follows and should explain **all the changes** you have made::

        Issue #1183 - Fix the world
        
        - Ozone layer now works properly, bug with C02 emissions.
        - Added class to handle doomsday scenario.
        
    5. Push the change to your account on *GITHub*::

        git push origin issue-1183

    6. Make a pull request to `ylly/master`

        1. Goto your *GITHub* **yProx** repository.
        2. Click "pull request"
        3. In the box on the right enter your branch name, `issue-1183`
        4. Click 'update commit range'
        5. Your commit message should be displayed, click "Make pull request".

    7. Your done. 

At the end of the week all the fixes can be reviewed and either merged into the **master** branch or
returned back to you for further modification.

.. note::

    When you finish an Issue you should mark the Issue as "closed" in redmine.

.. note::

    Never make changes to your master branch. You should keep this branch in the same state
    as the currently released code. This enables each change you make to be applied individually
    to the next release and enables us to pick and choose which changes to include.

After a release
===============

After a release it will be necessary for you to update your local repository with the new *stable* version of *yProximite*.

To do this checkout your master branch and **pull** from **ylly/master** as follows::

    git checkout master
    git pull ylly master

Note that you should have added the **ylly** origin as described earlier in this chapter.

Emergency Fixes - Creating a patch for the production server
============================================================

In the case that a bug needs to be fixed immediately (it cannot wait until the next release) you
can create a patch and apply it to the production server without deploying again.

1. Create ticket, branch and commit as detailed in previous section.

2. Create the patch

   1. As previously mentioned, your `master` branch should be the same as the master branch on
      `ylly/master`. Make sure this is the case.

   2. Create the patch, the following will create a file in the current directory, the filename will be generated from your commit message. Be sure to your commit message is formatted as previously mentioned for best results::

    git patch master

   3. Copy the patch to the production server::

        scp 0001-Issue-XXX-This-file-is-generated-by-git.patch
    
   4. Login to the production server, and change user to `yproxbuild` as previously detailed::

        ssh me@plombierweb.fr -p65022
        sudo -i
        su yproxbuild

   5. cd to the production `YProx` directory::

        cd /var/www/p/YProx/current

   6. Review changes in the patch::

        git apply --stat /home/me/0001-Issue-XXX-This-file-is-generated-by-git.patch

   7. Check that the patch can apply cleanly::

        git apply --check /home/me/0001-Issue-XXX-This-file-is-generated-by-git.patch

   8. If there is no output the patch will apply, if there are errors it will not. If you are good::

        git apply /home/me/0001-Issue-XXX-This-file-is-generated-by-git.patch

   9. Your are done.

