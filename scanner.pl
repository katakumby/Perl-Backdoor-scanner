#!/usr/bin/perl -w
# findshell v1.5 base code taken from traps.darkmindz.com modified  Marek (katakumby1996 gmail.com)
#usage: ./scanner.pl <sensitivity 1-50> <directory to scan>
use strict;
use File::Find;
my $sens = shift  || 10;
my $folder = shift || './';
find(\&backdoor, "$folder");
sub backdoor {
    if ((/\.(php|txt|phtml|php5|html)/)){
       open (my $IN,"<$_") || (print "can not open  $File::Find::name: $!" && next);
       my @file =  <$IN>;
       #maybe evil stuffs
       my $score = grep (/function_exists\(|phpinfo\(|safe_?mode|shell_exec\(|popen\(|passthru\(|system\(|myshellexec\(|exec\(|getpwuid\(|getgrgid  \(|fileperms\(/i,@file);
       #probably evil stuffs
       my $tempscore = grep(/\`\$\_(post|request|get).{0,20}\`|(include|require|eval|system|passthru|shell_exec).{0,10}\$\_(post|request|get)|eval.{0,10}base64_decode|back_connect|backdoor|r57|PHPJackal|PhpSpy|GiX|Fx29SheLL|w4ck1ng|milw0rm|PhpShell|k1r4|FeeLCoMz|FaTaLisTiCz|Ve_cENxShell|UnixOn|C99madShell|Spamfordz|Locus7s|c100|c99|x2300|cgitelnet|webadmin|cybershell|STUNSHELL|Pr!v8|PHPShell|KaMeLeOn|S4T|oRb|tryag|Hacker|sniper|a3v72ipr|A3V72IPR|iranonymous|azab siyah|noexecshell|\/etc\/passwd|revengans/i, @file);
       $score +=  50 *  $tempscore;
       print "$score - Possible backdoor : $File::Find::name\n" if ($score > $sens-1 );
       close $IN;
  }elsif((/\.(jpg|jpeg|gif|png|tar|zip|gz|rar|pdf)/)){
       open (my $IN,"<$_") || (print "can not open $File::Find::name: $!" && next);
       print "5000 - Possible backdoor (php in non-php file): $File::Find::name\n" if grep /(\<\?php|include(\ |\())/i, <$IN>;
       close $IN;
  }
}
