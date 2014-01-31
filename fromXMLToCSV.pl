#!/usr/bin/perl -w

# Convierte un fichero .xml sacado de Uniprot en un .csv calculando la cantidad de cada péptido por proteína,
# de cada dipéptido por proteína y número total de péptidos
# El resultado lo sacará por la salida estandar.

use warnings;
use strict;

if(scalar(@ARGV)<1) 
{
	die "Debes introducir el nombre del fichero .xml fuente\n";
}

local(*INFILE);

my @aas = ('A','C','D','E','F','G','H','I','K','L','M','N','P','Q','R','S','T','V','Y','W');
my @aaPairs = ();
foreach my $aa1 (@aas)
{
	foreach my $aa2 (@aas)
	{
		push(@aaPairs, $aa1.$aa2);
	}
}

print "Nombre,total,";
foreach my $aa (@aas)
{	
		print "$aa,";
}
foreach my $aa (@aaPairs)
{	
		print "$aa,";
}
print "Regiones transmembrana\n";

if(open(INFILE, $ARGV[0])) 
{
	my $line;
	# Por seguridad, limpio las variables
	my $sequence='';
	my $sequenceMode = 0;
	my $protName='';
	my $numRegions=0;
	# Procesamiento del fichero, leyendo línea a línea
	while($line=<INFILE>) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		
		if ($sequenceMode == 1)
		{
			if($line =~ /^<\/sequence>/) 
			{
				$sequenceMode = 0;
			}
			else
			{
				$sequence .= $line;
			}
		}
		
		
		# Detección del final del registro
		if($line =~ /^<\/entry>$/) 
		{				
			my %counters = ();
			my @seq = split('',$sequence);
			my $ant = ' ';
			my $comp;
			foreach my $s (@seq)
			{				
				# Para aminoácidos individuales
				if (exists($counters{$s}))
				{
					$counters{$s} ++;
				}
				else
				{
					$counters{$s} = 1;
				}
				# Para parejas de aminoácidos
				$comp = $ant . $s; 
				if (exists($counters{$comp}))
				{
					$counters{$comp} ++;
				}
				else
				{
					$counters{$comp} = 1;
				}
				$ant = $s;
			}
			
			print "$protName,";
			my $totalAAs = 0;
			foreach my $aa (@aas)
			{	
				if (exists($counters{$aa}))
				{
					$totalAAs += $counters{$aa};
				}
			}
			my $totalAAPairs = 0;
			foreach my $aa (@aaPairs)
			{	
				if (exists($counters{$aa}))
				{
					$totalAAPairs += $counters{$aa};
				}
			}
			print $totalAAs.",";
			foreach my $aa (@aas)
			{	
				if (exists($counters{$aa}))
				{
					printf "%.2f,", 100.*$counters{$aa}/$totalAAs;#Porcentaje de aminoácidos
					#print $counters{$aa}.",";#Total de aminoácidos
				}
				else
				{
					print "0,";
				}
			}
			foreach my $aa (@aaPairs)
			{	
				if (exists($counters{$aa}))
				{
					printf "%.2f,", 100.*$counters{$aa}/$totalAAPairs;#Porcentaje de aminoácidos
					#print $counters{$aa}.",";#Total de aminoácidos
				}
				else
				{
					print "0,";
				}
			}
			
			# Aquí podemos configurar los grupos de regiones
			if ($numRegions > 1){print "MORETHANONE\n";}
			#if ($numRegions > 6){print "MORETHANSIX\n";}
			#elsif ($numRegions > 1){print "TWO-SIX\n";}
			elsif ($numRegions == 1){print "ONE\n";}
			elsif ($numRegions == 0){print "ZERO\n";}
			#~ print " $numRegions\n";
						
			$sequence='';
			$protName='';
			$numRegions=0;
		}
		elsif($line =~ /^<name>(.*)<\/name>$/) 
		{
			if (length ($protName) == 0)
			{
				$protName = $1;
			}
		} 
		elsif($line =~ /^<feature type="transmembrane region"/) 
		{
			# Número de acceso
			$numRegions ++;
		} 
		elsif($line =~ /^<sequence length/) 
		{
			# Definición
			$sequenceMode=1;	
		} 
	}
	
	close(INFILE);
}
