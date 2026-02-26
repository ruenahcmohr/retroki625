use strict;
use warnings;

sub mm2mil { int($_[0] * 39.37 + ($_[0] >= 0 ? 0.5 : -0.5)) }


my %orient = (0=>"R",90=>"U",180=>"L",270=>"D");

my %fill = (none=>"N", background=>"F");

my %etype  = (
  input=>"I", output=>"O", bidirectional=>"B", passive=>"P",
  power_in=>"W", power_out=>"w",
  open_collector=>"C", open_emitter=>"E", no_connect=>"N"
);
my %idx = (Reference=>0, Value=>1, Footprint=>2, Datasheet=>3);

my $drawState = 0;
my $inp = do { local $/; <STDIN> };
my $last_pos ;

do {
  $last_pos = pos($inp) // 0;
  my $ref  = "U";
  my $unit_count = 1; # be my guest....
  
  if (0) {
  
   # } elsif  ($inp =~ /\G\s+/sgc) {
  } elsif  ($inp =~ /\G\s*\(kicad_symbol_lib[^\n]*/sgc) {
   #   printf "header dispose\n";

  } elsif  ($inp =~ /\G\s*\(symbol\s+\"(\w+)\"[^\n]*/sgc) {
     if ($drawState == 1) {
      printf "ENDDRAW\nENDDEF\n";
      $drawState = 0;
     }
      printf "DEF %s %s 0 40 Y Y %d F N\n",
        $1, $ref, $unit_count; 
 
  } elsif  ($inp =~ /\G\s+\(property\s+"([^"]+)"\s+"([^"]*)"\s+\(at\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\)\s+\(effects\s+\(font\s+\(size\s+([-\d.]+)\s+([-\d.]+)\)\)(\s+hide)?\)\s+\)/sgc) {
   my ($name,$val,$x,$y,$rot,$sx,$sy,$hide)=($1,$2,$3,$4,$5,$6,$7,$8);

   next unless exists $idx{$name};

    my $orient = ($rot==90)? "V" : "H";
    my $vis    = $hide ? "I" : "V";

    printf "F%d \"%s\" %d %d 50 %s %s C CNN\n",
      $idx{$name}, $val,
      mm2mil($x), mm2mil($y),
      $orient, $vis;       
  
  } elsif ($inp =~ /\G\s+\(pin\s+(\w+)\s+line\s+\(at\s+([-\d.]+)\s+([-\d.]+)\s+(\d+)\)\s+\(length\s+([-\d.]+)\).*?\(name\s+"([^"]+)".*?\(number\s+"([^"]+)"[^\n]*\s+\)/sgc) {
  
    if ($drawState == 0) {
      printf "DRAW\n";
      $drawState = 1;
    }
  
    my ($type,$x,$y,$ang,$len,$name,$num)=($1,$2,$3,$4,$5,$6,$7);

    printf "X %s %s %d %d %d %s 50 50 1 1 %s\n",
      $name, $num,
      mm2mil($x), mm2mil($y), mm2mil($len),
      $orient{$ang} // "R",
      $etype{$type} // "P";
  
  } elsif ($inp =~ /\G\s+\(rectangle\s+\(start\s+([-\d.]+)\s+([-\d.]+)\)\s+\(end\s+([-\d.]+)\s+([-\d.]+)\)\s+\(stroke\s+\(width\s+([-\d.]+)\)[^)]*\)\)\s+\(fill\s+\(type\s+(none|background)\)\)\s*\)/sgc ) {
    if ($drawState == 0) {
      printf "DRAW\n";
      $drawState = 1;
    }
  
    printf "S %d %d %d %d 0 1 0 %s\n",
      mm2mil($1), mm2mil($2),
      mm2mil($3), mm2mil($4),
      $fill{$6};
      
      
#  $inp =~ /\G\s*\(polyline\s+\(pts\s+((?:\(xy\s+[-\d.]+\s+[-\d.]+\)\s*)+)\)\s+\(stroke\s+\(width\s+([-\d.]+)\)[^)]*\)(?:\s+\(fill\s+\(type\s+(none|background)\)\))?\s*\)/sgc) {
#
#  my @pts = ($1 =~ /\(xy\s+([-\d.]+)\s+([-\d.]+)\)/g);
#
#  my $count = @pts / 2;
#
#  print "P $count 0 1 0 ";
#  while (@pts) {
#    printf "%d %d ", mm2mil(shift @pts), mm2mil(shift @pts);
#  }
#  print "N\n";
# }
#   


#
#   $inp =~ /\G\s*\(circle\s+\(center\s+([-\d.]+)\s+([-\d.]+)\)\s+\(radius\s+([-\d.]+)\)\s+\(stroke\s+\(width\s+([-\d.]+)\)[^)]*\)(?:\s+\(fill\s+\(type\s+(none|background)\)\))?\s*\)/xsgc) {
#
#   printf "C %d %d %d 0 1 0 N\n",
#     mm2mil($1),
#     mm2mil($2),
#     mm2mil($3);                                                                                                                                                                               
#  }
#



#  $inp =~ /\G\s*\(arc\s+\(start\s+([-\d.]+)\s+([-\d.]+)\)\s+\(mid\s+([-\d.]+)\s+([-\d.]+)\)\s+\(end\s+([-\d.]+)\s+([-\d.]+)\)\s+\(stroke\s+\(width\s+([-\d.]+)\)[^)]*\)\s*\)/xsgc) {
#
#  my ($sx,$sy,$mx,$my,$ex,$ey) = ($1,$2,$3,$4,$5,$6);
#
#  my $r = sqrt(($sx-$mx)**2 + ($sy-$my)**2);
#
#  printf "A %d %d %d 0 1800 0 1 0 N %d %d %d %d\n",
#    mm2mil($mx),
#    mm2mil($my),
#    mm2mil($r),
#    mm2mil($sx),
#    mm2mil($sy),
#    mm2mil($ex),
#    mm2mil($ey);
# }
#
#
#


      
      
         
  } elsif ($inp =~ /\G\s+\)/sgc ) {
   #  printf "disposed of close brace\n";               
                    
  }
  
  
      
} while ((pos($inp) // 0) != $last_pos);

