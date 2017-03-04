#!perl

use strict;
use warnings;
use HTTP::Request;
use LWP::UserAgent;
use Test::More;
use Try::Tiny qw(try catch);
use Test::RequiresInternet ('test.rebex.net' => 22);

plan tests => 8;

my $ua = LWP::UserAgent->new(timeout => 5);

{ # test a connection with username and pass
    my $url = 'ftp://demo:password@test.rebex.net/';

    my ($response, $error);
    try {
        my $req = HTTP::Request->new('GET', $url);
        $req->content_type("text/ftp-dir-listing");
        my $res = $ua->request($req);
        unless($res->is_success) {
            die "Couldn't get info: ".$res->status_line;
        }
        $response = $res->decoded_content;
    }
    catch {
        $error = $_;
        $response = undef;
    };
    ok($response, "$url - got listing");
    is($error, undef, "$url - no errors");
}

{ # test a connection with username and pass and path
    my $url = 'ftp://demo:password@test.rebex.net/pub/example';

    my ($response, $error);
    try {
        my $req = HTTP::Request->new('GET', $url);
        $req->content_type("text/ftp-dir-listing");
        my $res = $ua->request($req);
        unless($res->is_success) {
            die "Couldn't get info: ".$res->status_line;
        }
        $response = $res->decoded_content;
    }
    catch {
        $error = $_;
        $response = undef;
    };
    ok($response, "$url - got listing");
    is($error, undef, "$url - no errors");
}

{ # test a connection with username and pass and bad path
    my $url = 'ftp://demo:password@test.rebex.net/bad-path';

    my ($response, $error);
    try {
        my $req = HTTP::Request->new('GET', $url);
        $req->content_type("text/ftp-dir-listing");
        my $res = $ua->request($req);
        unless($res->is_success) {
            die "Couldn't get info: ".$res->status_line;
        }
        $response = $res->decoded_content;
    }
    catch {
        $error = $_;
        $response = undef;
    };
    is($response, undef, "$url - no listing");
    ok($error, "$url - got errors");
}

{ # test a connection failure with bad username and pass
    my $url = 'ftp://bad-user:password@test.rebex.net/';

    my ($response, $error);
    try {
        my $req = HTTP::Request->new('GET', $url);
        $req->content_type("text/ftp-dir-listing");
        my $res = $ua->request($req);
        unless($res->is_success) {
            die "Couldn't get info: ".$res->status_line;
        }
        $response = $res->decoded_content;
    }
    catch {
        $error = $_;
        $response = undef;
    };
    is($response, undef, "$url - no listing");
    ok($error, "$url - got errors");
}
