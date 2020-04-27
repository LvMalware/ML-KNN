use strict;
use lib '.';
use warnings;
use KNN;
use KNN::Element;
my $knn = KNN->new(dataset_file => 'example-dataset/iris_test/iris_1-100.txt', k => 11);
open my $test_data, '< :encoding(UTF-8)', 'example-dataset/iris_test/iris_101-150.txt';
my $correct = 0;
$knn->load_dataset();
while (<$test_data>)
{
    my $element = KNN::Element->from_string($_);
    $correct ++ if $knn->classify($element) eq $element->name();
}

print "CORRECT: $correct/50\n";