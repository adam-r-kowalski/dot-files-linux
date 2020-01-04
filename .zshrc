export ZSH="/home/adam/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git z)

export QT_AUTO_SCREEN_SCALE_FACTOR=1

source $HOME/.profile
source $ZSH/oh-my-zsh.sh

PATH="/home/adam/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/adam/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/adam/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/adam/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/adam/perl5"; export PERL_MM_OPT;
