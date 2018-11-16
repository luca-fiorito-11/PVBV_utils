apt-get gfortran-5

curl -o fizcon.f90 "https://www-nds.iaea.org/public/endf/utility/bin/fizcon.f" -k
${FC} -o fizcon fizcon.f90
