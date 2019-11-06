# Kanine Altercation

An arena style mmo dogfight. Started life as a side project on Helix's Perisher offsite between @prunge and @jeeva

## Game mechanics

 - One shot kills
 - Ships have a noticeable reload delay, and there is no UI feedback as to when you can fire
 - If ships collide, hit arena edges or space-junk/asteroids, they slide of each other

## Client/Server
 - Needs client side prediction, reconciliation and interpolation to be smooth
 - see: https://www.gabrielgambetta.com/lag-compensation.html
 - see: https://www.gabrielgambetta.com/client-side-prediction-live-demo.html

# Dev

    sudo apt-get build-dep love
    sudo apt-get install mercurial
    hg clone ssh://hg@bitbucket.org/rude/love
    cd love; mkdir build; cd build; cmake -DCMAKE_BUILD_TYPE=Release ..
    make -j 8

    cd ${gamedir}
    ${lovebuilddir}/love .
