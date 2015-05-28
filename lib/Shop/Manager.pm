package Shop::Manager;
use Dancer ':syntax';
use Shop::DB;

prefix '/manager';

get '/' => sub {
    template 'index';
};

prefix undef;

true;