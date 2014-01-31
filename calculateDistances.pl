#!/usr/bin/perl -w

# De un fichero .csv se calcula todas las distancias. En este caso es
# la suma de las diferencias de los porcentajes de dipéptidos. Si las proteínas
# tienen el mismo número de regiones transmembrana, la distancia será 9999999
# el resultado se da por la salida estándar



use warnings;
use strict;

if(scalar(@ARGV)<1) 
{
	die "Debes introducir el nombre del fichero .csv fuente\n";
}

my @instances = ();

local(*INFILE);

#Leemos todas las instancias del fichero
if(open(INFILE, $ARGV[0])) 
{
	my $line;
	#Desestimamos primera línea de cabeceras
	$line=<INFILE>;
	while($line=<INFILE>) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		my @inst = split(',',$line);
		push(@instances, [@inst]);
	}	
	close(INFILE);
}


my ($i, $j, $dist);

# calculo las distancias y se sacan por pantalla separadas por comas
for ($i = 0; $i < scalar(@instances); $i++)
{
	for ($j = 0; $j < scalar(@instances); $j++)
	{
		if ($j <= $i)
		{
			$dist = 0;
		}
		else
		{
			$dist = arrayDistance(\@{$instances[$i]},\@{$instances[$j]});
		}
		if ($j != 0)
		{
			print ",";
		}
		print $dist;
	}
	print "\n";
}


sub arrayDistance 
{
	my ($array1,$array2) = @_;
	my $sum = 0;
	if ($array1->[422] ne $array2->[422])# Si no tiene las mismas regiones transmembrana no seguimos
	{
		return 9999999;
	}
	for (my $i = 22; $i < 422; $i++)
	{
		$sum += abs($array1->[$i] - $array2->[$i]);
	}
	return $sum;
}
