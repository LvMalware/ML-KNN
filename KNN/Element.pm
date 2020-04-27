package KNN::Element;

use strict;
use warnings;
use List::Util 'sum';

#Overload these functions to fit your needs

sub new
{
    my ($self, %args) = @_;
    my $data = {
        data => $args{data},
        name => $args{name} || ''
    };

    bless $data, $self;
}

sub name
{
    my ($self, $new) = @_;
    $self->{name} = $new if defined($new);
    $self->{name}
}

sub data
{
    my ($self, $new) = @_;
    $self->{data} = $new if defined($new);
    $self->{data}
}

# Euclidean distance

sub get_distance
{
    my ($self, $other) = @_;
    die "$0: You must provide an Element object to get the distance" unless defined($other);
    sqrt(sum map { ($self->{data}->[$_] - $other->{data}->[$_]) ** 2 } 0 .. @{$self->{data}} - 1)
}

sub from_string
{
    my ($self, $str) = @_;
    die "$0: Invalid string" unless (defined($str) && length($str) > 0);
    my @data = split / /, $str;
    chomp(my $name = pop @data);
    bless { name => $name, data => [@data] }, $self;
}

sub to_string
{
    my ($self) = @_;
    join ' ', (@{$self->{data}}, $self->{name})
}

1;
