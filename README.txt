sh
--------------------------------------------------------------------------------
personal collections of scripts, really powerful when combined with dmenu[1] or
with rofi in its dmenu compatibility mode


history
--------------------------------------------------------------------------------
in my early days using linux i though that the right way to make my scripts
available across the system was to directly symlink them to /usr/bin, which was
quickly proven to be the worst solution, since not only did it required a lot of
maintenance, but it also didn't worked as expected

enter the $PATH env variable

ever since i've been working and perfecting a simpler and way more maintainable
solution for my scripting needs, combining the link.sh, .gitignore and a
predictable folder and file naming convention


usage
--------------------------------------------------------------------------------
1. add the sh folder path to the $PATH env variable in your bash/zsh/sh profile
2. open your terminal and move to the sh folder

   > cd ~/sh/

3. run the link.sh script

   > ./link.sh

4. (optional) inspect the current folder, you should see a bunch of new symlinks
   all pointing to scripts contained in folders like utils/

   > ls -la

5. if everything went fine, you should now be able to run any of those symlinked
   scripts anywhere, since they are now available via the $PATH env variable

   > cd ; wallpainter


how
--------------------------------------------------------------------------------
for those interested in either extending or modifying the project, you should
know a couple of things:

a. if the script you're working on requires some user-defined variables, you
   should, ideally, read that data from an external file, making the commits
   easier and free from unsuspected local changes, see $WORKSPACES from the
   dcompose/dcutils.sh script
b. if you're trying to ignore any given file, you should define its path in the
   $IGNORE variable within the link.sh script, since every time link.sh is
   executed, it'll completely overwrite the .gitignore file
c. you can make as many subfolders as you want, as long as you understand
   that ONLY the scripts contained in the immediate subfolders will be exposed

   for example, say we have this folder structure:

      sh/
         my-custom-scripts/
            first.sh
            my-specialized-scripts/
               second.sh

   what we'll have after running the link.sh script is:

      sh/
         first* -> ~/sh/my-custom-scripts/first.sh
         my-custom-scripts/
            first.sh
            my-specialized-scripts/
               second.sh

d. the intended structure for this project is to have as many immediate
   subfolders named after relevant topics as we need, containing any number of
   scripts related to said topic

   whenever a given script has grown so much that isn't maintainable in a single
   script anymore, we, ideally, should now create a folder specially for it, and
   start decomposing it

   for example, the tasker script started as shortcut to quickly open the
   taskwarrior-tui, then i decided to make a specialized git repo to start
   committing my tasks, so now i needed some custom actions like pull, commit,
   stash, open and prepare

   this is when the tasks/ folder was created to contain tasker.sh, the entry
   script, and the tasks/actions subfolder, which contains specialized scripts
   that extend tasks/tasker.sh capabilities

   for another example, take a look at dcompose/dcutils.sh or heroku/herutils.sh


resource
--------------------------------------------------------------------------------
[1] many many hours of reading, trying and debugging
