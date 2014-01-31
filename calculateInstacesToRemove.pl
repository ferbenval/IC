#!/usr/bin/perl -w

# De un fichero .csv y un fichero de las proteínas más parecidas de ese .csv se calcula
# otro fichero de las proteínas que tienen distancia menor entre sí(menos parecidas entre sí). 


use warnings;
use strict;

if(scalar(@ARGV)<4) 
{
	die "Debes introducir en este orden:\n-el nombre del fichero .csv de donde quitar las instancias\n".
			"-el fichero de distancias para el .csv\n-el número de instancias a quitar\n-el fichero donde guardarlas\n";
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
		#print @inst[0..4],"\n";
		push(@instances, [@inst]);
	}	
	close(INFILE);
}

my $minDist = 9999999;
my $indexi = 0;
my $indexj = 0;
my $dist = 0;
my @distances = ();
my @rowdistances = ();
my $i;
my $j;
my $line;
my $counter = 0;

# Leemos el fichero de distancias
if(open(DISTANCESFILE, $ARGV[1])) 
{
	while($line=<DISTANCESFILE>) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		@rowdistances = split(',',$line);
		push(@distances, [@rowdistances]);
		$counter ++;
		if (($counter % 50) == 0) 
		{
			print "**$counter**\n";
		}
	}	
	close(DISTANCESFILE);
}
else
{
	die "###Error: No puedo abrir el fichero '$ARGV[1]'";
}

my @removed = [];
open(REMOVEDFILE, ">",$ARGV[3]) or die "###Error: No puedo abrir el fichero '$ARGV[3]'";
for (my $count = 0; $count < $ARGV[2]; $count ++)
{
	$minDist = 9999999;
	for ($i = 0; $i < scalar(@instances); $i++)
	{
		if ($i ~~ @removed)
		{
			next;
		}
		for ($j = $i+1; $j < scalar(@instances); $j++)
		{
			$dist = @{$distances[$i]}[$j];
			if ($dist < $minDist)
			{
				$minDist = $dist;
				print "$minDist\n";
				$indexi = $i;
				$indexj = $j;
			}
		}
	}
	print "**$count: $minDist, $indexi, $indexj\n";
	push (@removed,$indexi);
	print REMOVEDFILE "$indexi, $minDist\n";
	flush(*REMOVEDFILE);
}
close (REMOVEDFILE);

sub flush 
{
  my $h = select($_[0]); my $af=$|; $|=1; $|=$af; select($h);
}
#!/usr/bin/perl -w

# De un fichero .csv y un fichero de las proteínas más parecidas de ese .csv se calcula
# otro fichero de las proteínas que tienen distancia menor entre sí(menos parecidas entre sí). 


use warnings;
use strict;

if(scalar(@ARGV)<4) 
{
	die "Debes introducir en este orden:\n-el nombre del fichero .csv de donde quitar las instancias\n".
			"-el fichero de distancias para el .csv\n-el número de instancias a quitar\n-el fichero donde guardarlas\n";
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
		#print @inst[0..4],"\n";
		push(@instances, [@inst]);
	}	
	close(INFILE);
}

my $minDist = 9999999;
my $indexi = 0;
my $indexj = 0;
my $dist = 0;
my @distances = ();
my @rowdistances = ();
my $i;
my $j;
my $line;
my $counter = 0;

# Leemos el fichero de distancias
if(open(DISTANCESFILE, $ARGV[1])) 
{
	while($line=<DISTANCESFILE>) 
	{
		# Lo primero, quitar el salto de línea
		chomp($line);
		@rowdistances = split(',',$line);
		push(@distances, [@rowdistances]);
		$counter ++;
		if (($counter % 50) == 0) 
		{
			print "**$counter**\n";
		}
	}	
	close(DISTANCESFILE);
}
else
{
	die "###Error: No puedo abrir el fichero '$ARGV[1]'";
}

my @removed = [];
open(REMOVEDFILE, ">",$ARGV[3]) or die "###Error: No puedo abrir el fichero '$ARGV[3]'";
for (my $count = 0; $count < $ARGV[2]; $count ++)
{
	$minDist = 9999999;
	for ($i = 0; $i < scalar(@instances); $i++)
	{
		if ($i ~~ @removed)
		{
			next;
		}
		for ($j = $i+1; $j < scalar(@instances); $j++)
		{
			$dist = @{$distances[$i]}[$j];
			if ($dist < $minDist)
			{
				$minDist = $dist;
				print "$minDist\n";
				$indexi = $i;
				$indexj = $j;
			}
		}
	}
	print "**$count: $minDist, $indexi, $indexj\n";
	push (@removed,$indexi);
	print REMOVEDFILE "$indexi, $minDist\n";
	flush(*REMOVEDFILE);
}
close (REMOVEDFILE);

sub flush 
{
  my $h = select($_[0]); my $af=$|; $|=1; $|=$af; select($h);
}
