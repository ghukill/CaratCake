# Load RVM into a shell session *as a function*
if [[ -s "/home/commander/.rvm/scripts/rvm" ]] ; then

  # First try to load from a user install
  source "/home/commander/.rvm/scripts/rvm"

elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then

  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"

else

  printf "ERROR: An RVM installation was not found.\n"

fi

# start server
ruby cc.rb -o 192.168.1.16
