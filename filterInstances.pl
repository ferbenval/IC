#!/usr/bin/perl -w

# de un fichero .csv se sacan las proteínas indicadas por otro fichero en el que 
# aparecen las proteínas que más se parecen entre sí
# El resultado aparecerá por la salida estándar


use warnings;
use strict;

if(scalar(@ARGV)<3) 
{
	die "Debes introducir en este orden:\n-el nombre del fichero .csv de donde quitar las instancias\n".
			"-el número de proteínas a quitar\n-el nombre del fichero donde aparecen las proteínas a quitar\n";
}

my @instances = ();
my $line;

#Leemos todas las instancias del fichero
if(open(INFILE, $ARGV[0])) 
{
	while($line=<INFILE>) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		push(@instances, $line);
	}	
	close(INFILE);
}
else
{
	die "###Error: No puedo abrir el fichero '$ARGV[0]'";
}


# Leemos el fichero de proteinas parecidas, pero sólo el número especificado en el 2º parámetro
my @removedList = ();
my @removed = ();
my $counter = 0;
if(open(REMOVEDFILE, $ARGV[2])) 
{
	while(($line=<REMOVEDFILE>)) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		@removed = split(',',$line);
		push(@removedList, $removed[0]);
		$counter++;
		if ($counter>=$ARGV[1])
		{
			last;
		}
	}	
	close(REMOVEDFILE);
}
else
{
	die "###Error: No puedo abrir el fichero '$ARGV[2]'";
}

# Sacamos la salida
my $count = -1;
foreach my $inst (@instances)
{
	if ($count ~~ @removedList)
	{
		$count++;
		next;
	}
	print "$inst\n";
	$count++;
}
