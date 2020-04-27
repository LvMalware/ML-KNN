package KNN;

use strict;
use lib '.';
use warnings;
use KNN::Element;
use base 'Exporter';

our $VERSION = 0.1;
#our @EXPORT  = qw();

sub new
{
    my ($self, %args) = @_;
    my $data = {
        dataset_file => $args{dataset_file},
        k => $args{k} || die "$0: You must provide a value for K"
    };

    bless $data, $self;
}

sub load_dataset
{
    my ($self, $filename) = @_;
    open(my $dataset, "< :encoding(UTF-8)", defined($filename) ? $filename : $self->{dataset_file}) ||
        die "$0: Can't open dataset file: $!";
    #######################################################################################
    # Each line of the dataset file must contain the parameters and the name of the class #
    # separated by a space. Example:                                                      #
    # 5.1 3.5 1.4 0.2 Iris-setosa                                                         #
    #######################################################################################
    my @lines = <$dataset>;
    #my @config = split / /, shift @lines; #TODO: add configuration support
    $self->{elements} =  [ map { KNN::Element->from_string($_) } @lines ]
}

sub classify
{
    my ($self, $element, $k) = @_;
    die "$0: Invalid element" unless defined($element) && ref($element) =~ /Element/;
    die "$0: You must load the dataset first" unless defined($self->{elements});
    $k = $self->{k} unless defined($k);
    $k ++ unless $k % 2;
    my @best = (sort { $element->get_distance($a) <=> $element->get_distance($b) } @{$self->{elements}})[0 .. $k - 1];
    my %score;
    $score{$_->name()} ++ for @best;
    (sort { $score{$a} <=> $score{$b} } keys %score)[-1]
}

1;
