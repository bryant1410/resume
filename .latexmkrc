use File::Copy;

$pdf_mode = 1;
$bibtex_use = 2;
$out_dir = 'output';
$latex = 'lualatex --shell-escape';
$pdflatex = 'lualatex --shell-escape';

@default_files = ('main.tex');

# Only generate santi-cv.pdf if the private/ directory exists
if (-d 'private') {
    if (! -f 'santi-cv.tex') {
        open my $fh, '>', 'santi-cv.tex';
        print $fh "% Auto-generated private wrapper for main.tex\n";
        print $fh "\\def\\forceprivate{1}\n";
        print $fh "\\input{main.tex}\n";
        close $fh;
    }
    push @default_files, 'santi-cv.tex';
}

$success_cmd = 'internal copy_private_cv %B %D';
sub copy_private_cv {
    my ($base, $pdf) = @_;
    return 0 unless ($base eq 'santi-cv' && -f $pdf && -d 'private');

    my $target = 'private/santi-cv.pdf';
    if (copy($pdf, $target)) {
        print "Latexmk: Copied private CV '$pdf' -> '$target'\n";
    } else {
        warn "Latexmk: Failed to copy to '$target': $!\n";
    }
    return 0;
}
