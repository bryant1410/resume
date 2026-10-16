%%%%%%%%%%%%%%%%%
% This is altacv.cls (v1.1.5, 1 December 2018) written by
% LianTze Lim (liantze@gmail.com).
%
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%%
%%
% Contributions:
% - https://github.com/akreuzer Added ragged2e option (5 Nov 2018)
% - https://github.com/stefanogermano Fixed bad boxes and undefined font shape (July 2018)
% - https://github.com/foohyfooh Fixed blank spaces in \cvevent and bad link in README.md (June 2018)

%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
%% v1.4: Detect TL2018 to handle accented characters in class information
\@ifl@t@r\fmtversion{2018/04/01}{\UseRawInputEncoding}{}
\ProvidesClass{altacv}[2025/07/30 AltaCV v1.7.4, yet another alternative class for a resume/curriculum vitae.]

%% v1.1: Optionally load academicons
%% v1.4: Nope, academicons is unnecessary; fontawesome5 has \faOrcid.
%% v1.7.3: Re backward compatibility we'll now load academicons automatically for \aiOrcid if ≤TL2019 i.e. if \faOrcid undefined
\DeclareOption{academicons}{\ClassWarning{altacv}{academicons option is now obsolete and unnecessary.}}
%% v1.1.3: Choice of round/square photo
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
%% v1.3: load hyperref for clickable hyperlinks
\newif\if@withhyper\@withhyperfalse
\DeclareOption{withhyper}{\@withhypertrue}
\ProcessOptions\relax

\LoadClass{extarticle}
\RequirePackage{etoolbox}
\newtoggle{withhyper}\togglefalse{withhyper}
\if@withhyper\toggletrue{withhyper}\fi
\RequirePackage{xparse}

\RequirePackage[margin=2cm]{geometry}
\geometry{left=1cm,right=9cm,marginparwidth=6.8cm,marginparsep=1.2cm,top=1cm,bottom=1cm}

\RequirePackage[fixed]{fontawesome5}
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}

% v1.7.2 Add simpleicons to provide X icon
\IfFileExists{simpleiconsglyphs-pdftex.tex}{\RequirePackage{simpleicons}}{}

%% v1.1.5: added for convenience
\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

\RequirePackage{xcolor}

\definecolor{Vivid}{HTML}{000000}
\definecolor{SlateGrey}{HTML}{2E2E2E}
\definecolor{LightGrey}{HTML}{666666}
\definecolor{LighterGrey}{HTML}{888888}
\colorlet{heading}{Vivid}
\colorlet{headingrule}{heading}
\colorlet{accent}{Vivid}
\colorlet{emphasis}{SlateGrey}
\colorlet{subheading}{emphasis}
\colorlet{name}{emphasis}
\colorlet{tagline}{accent}
\colorlet{body}{LightGrey}
\colorlet{inner-body}{LighterGrey}
% Renamed or added v1.7
\newcommand{\cvItemMarker}{{\small\textbullet}}
\newcommand{\cvRatingMarker}{\faCircle}
\let\itemmarker\cvItemMarker      % for backward compatibility
\let\ratingmarker\cvRatingMarker  % for backward compatibility
\newcommand{\cvDateMarker}{\faCalendar[regular]}
\newcommand{\cvLocationMarker}{\faMapMarker}
\newcommand{\locationname}{Location}
\newcommand{\datename}{Date}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.25\baselineskip,after=\vskip0.25\baselineskip}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{etoolbox}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

\providecommand{\faChain}{\faLink}
\newcommand{\emailsymbol}{\faAt}
\newcommand{\phonesymbol}{\faPhone}
\newcommand{\homepagesymbol}{\faGlobe}
\newcommand{\locationsymbol}{\cvLocationMarker}
\newcommand{\linkedinsymbol}{\faLinkedin}
\newcommand{\twittersymbol}{\faTwitter}
\newcommand{\githubsymbol}{\faGithub}
\ifundef{\orcidsymbol}{%
  \ifdef{\faOrcid}{%
    \newcommand{\orcidsymbol}{\faOrcid}%
  }{%
    \ifxetexorluatex
      \IfFileExists{academicons.sty}{%
        \RequirePackage{academicons}%
        \newcommand{\orcidsymbol}{\aiOrcid}%
      }{%
        \newcommand{\orcidsymbol}{ORCID}%
      }%
    \else
      \newcommand{\orcidsymbol}{ORCID}%
    \fi
  }%
}{}
\newcommand{\mailsymbol}{\faEnvelope}
\ifcsdef{simpleicon@xicon}{%
  \newcommand{\xtwittersymbol}{\raisebox{-0.1ex}{\small\simpleicon{x}}\kern 0.1em}%
}{%
  \let\xtwittersymbol\twittersymbol
}

\csdef{altacv@label@email}{Email}
\csdef{altacv@label@mailaddress}{Address}
\csdef{altacv@label@phone}{Phone}
\csdef{altacv@label@homepage}{Homepage}
\csdef{altacv@label@twitter}{Twitter}
\csdef{altacv@label@xtwitter}{X}
\csdef{altacv@label@linkedin}{LinkedIn}
\csdef{altacv@label@github}{GitHub}
\csdef{altacv@label@orcid}{ORCID}
\csdef{altacv@label@location}{Location}
\csdef{altacv@label@googlescholar}{Google Scholar}
\csdef{altacv@label@stackoverflow}{Stack Overflow}
\csdef{altacv@label@home}{Home}

\NewDocumentCommand{\printinfo}{o m m o}{%
  \IfNoValueTF{#1}{%
    \def\altacv@curlabel{\detokenize{#2}}%
  }{%
    \ifcsdef{altacv@label@#1}{%
      \def\altacv@curlabel{\csuse{altacv@label@#1}}%
    }{%
      \def\altacv@curlabel{#1}%
    }%
  }%
  \IfNoValueTF{#4}{%
    \mbox{\textcolor{accent}%
    {\BeginAccSupp{method=escape,ActualText={\altacv@curlabel:\space}}\normalfont #2\EndAccSupp{}}%
    \hspace{0.5em}#3\hspace{2em}}%
  }{% v1.7.4: fix accsupp ActualText bugs when withhyper enabled
    \iftoggle{withhyper}{%
      \mbox{\textcolor{accent}%
      {\BeginAccSupp{method=escape,ActualText={\altacv@curlabel:\space}}\normalfont #2\EndAccSupp{}}%
      \hspace{0.5em}%
      \BeginAccSupp{method=escape,ActualText={#4}}%
      \href{#4}{#3}%
      \EndAccSupp{}%
      \hspace{2em}}%
     }{%
       \ClassWarning{altacv}{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix for #1 now.}%
      \mbox{\textcolor{accent}%
      {\BeginAccSupp{method=escape,ActualText={\altacv@curlabel:\space}}\normalfont #2\EndAccSupp{}}%
      \hspace{0.5em}{#4}\hspace{2em}}%
    }%
  }%
}

%% v1.3: Convenient creation of fields
%% v1.6: Starred mode to create \printinfo with full URL
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanF{#1}{%
    \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
  }%
  \csdef{#2 symbol}{#3}%
  \IfBooleanTF{#1}%
    { \csdef{#2}##1##2{%
        \IfNoValueTF {##2}%
          {\printinfo[#2]{\csuse{#2 symbol}}{##1}}%
          {\printinfo[#2]{\csuse{#2 symbol}}{##1}[##2]}%
      }%
    }%
    { \csdef{#2}##1{%
        \IfNoValueTF {#4}%
          {\printinfo[#2]{\csuse{#2 symbol}}{##1}}%
          {\printinfo[#2]{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
      }%
    }%
}

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\photo}[2]{\def\@photo{#2}\def\@photodiameter{#1}}

\NewInfoField{email}{\emailsymbol}[mailto:]
\NewInfoField{mailaddress}{\mailsymbol}
\NewInfoField{phone}{\phonesymbol}[tel:]
\NewInfoField{homepage}{\homepagesymbol}[https://]
\NewInfoField{twitter}{\twittersymbol}[https://twitter.com/]
\NewInfoField{xtwitter}{\xtwittersymbol}[https://x.com/]
\NewInfoField{linkedin}{\linkedinsymbol}[https://linkedin.com/in/]
\NewInfoField{github}{\githubsymbol}[https://github.com/]
\NewInfoField{orcid}{\orcidsymbol}[https://orcid.org/]
\NewInfoField{location}{\locationsymbol}
\NewInfoField*{googlescholar}{\faGraduationCap}
\NewInfoField*{stackoverflow}{\faStackOverflow}
\NewInfoField{home}{\faHome}

\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}

\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\footnotesize\bfseries}
\newcommand{\cvsectionfont}{\normalsize\bfseries}
\newcommand{\cvsubsectionfont}{}

\newcommand{\makecvheader}{%
  \begingroup
    \ifdef{\@photodiameter}{\begin{minipage}{\dimexpr\linewidth-\@photodiameter-2em}}{}%
    \raggedright%
    {\namefont\color{name}\MakeUppercase{\@name}\par}
    \medskip
    {\taglinefont\color{tagline}\@tagline\par}
    \medskip
    {\personalinfofont\color{emphasis}\@personalinfo\par}
    \ifdef{\@photodiameter}{%
    \end{minipage}\hfill%
    \begin{minipage}{\@photodiameter}
    \if@normalphoto
      \includegraphics[width=\linewidth]{\@photo}
    \else
      \tikz\path[fill overzoom image={\@photo}]circle[radius=0.5\linewidth];
    \fi%
    \end{minipage}\par}{}%
  \endgroup\medskip
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
  \ifstrequal{#2}{}{}{\medskip}%
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  \ifstrequal{#2}{}{}{{\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{.5pt}\par}\medskip}
}

\newcommand{\cvsubsection}[1]{%
  \smallskip%
  {\color{subheading}\cvsubsectionfont{#1}\par}\smallskip
}

% v1.1.4: fixes inconsistent font size
\newcommand{\cvevent}[5]{%
  \normalsize%
  {\color{emphasis}#1}%
  \ifstrequal{#2}{}{}{, \textbf{\color{accent}#2}}%
  \ifstrequal{#3}{}{}{{, {\small#3}}}%
  \ifstrequal{#4}{}{}{{,~{\small#4}}}\par%
  \ifstrequal{#5}{}{}{\smallskip {\color{inner-body}\small#5}}%
  \bigskip
}

\newcommand{\cvsmallevent}[5]{%
  \small%
  {\color{emphasis}#1}%
  \ifstrequal{#2}{}{}{, \textbf{\color{accent}#2}}%
  \ifstrequal{#3}{}{}{, {\footnotesize#3}}%
  \ifstrequal{#4}{}{}{,~{\footnotesize#4}}\par%
  \ifstrequal{#5}{}{}{\smallskip {\color{inner-body}\footnotesize#5}}%
  \medskip
}

\newcommand{\cvachievement}[2]{%
  \small%
  \textcolor{emphasis}{#1}, #2%
  \smallskip
}

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

% v1.6: Use accsupp so that the actual numeric value is copied/pasted
%       and also support 0.5, 1.5, 2.5, 3.5, 4.5
\newcommand{\cvskill}[2]{%
  \textcolor{emphasis}{\textbf{#1}}\hfill
  \BeginAccSupp{method=plain,ActualText={#2}}
  \foreach \x in {1,...,5}{%
    \ifdimequal{\x pt - #2 pt}{0.5pt}%
    {\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}\cvRatingMarker}%
     \clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}\cvRatingMarker}}
    {\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}\cvRatingMarker}%
  }\EndAccSupp{}\par%
}

% Adapted from @Jake's answer at http://tex.stackexchange.com/a/82729/226
\newcommand{\wheelchart}[4][0]{%
    \begingroup\centering
    \def\innerradius{#3}%
    \def\outerradius{#2}%
    % Calculate total
    \pgfmathsetmacro{\totalnum}{0}%
    \foreach \value/\colour/\name in {#4} {%
        \pgfmathparse{\value+\totalnum}%
        \global\let\totalnum=\pgfmathresult%
    }%
    \begin{tikzpicture}

      % Calculate the thickness and the middle line of the wheel
      \pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      \pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}
      \pgfmathsetmacro{\totalrot}{-90 + #1}

      % Rotate so we start from the top
      \begin{scope}[rotate=\totalrot]

      % Loop through each value set. \cumnum keeps track of where we are in the wheel
      \pgfmathsetmacro{\cumnum}{0}
      \foreach \value/\width/\colour/\name in {#4} {
            \pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            % Calculate the percent value
            \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            % Calculate the mid angle of the colour segments to place the labels
            \pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            % This is necessary for the labels to align nicely
            \pgfmathparse{
               (-\midangle>180?"west":"east")
            } \edef\textanchor{\pgfmathresult}
            \pgfmathparse{
               (-\midangle>180?"flush left":"flush right")
            } \edef\textalign{\pgfmathresult}
            \pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            % Draw the color segments. Somehow, the \midrow units got lost, so we add 'pt' at the end. Not nice...
            \filldraw[draw=white,fill=\colour] (-\cumnum:\outerradius) arc (-\cumnum:-(\newcumnum):\outerradius) --
            (-\newcumnum:\innerradius) arc (-\newcumnum:-(\cumnum):\innerradius) -- cycle;

            % Draw the data labels
            % v1.6: Use accsupp so that the numeric number is copied/pasted too
            \draw  [*-,thin,emphasis] node [append after command={(\midangle:\midradius pt) -- (\midangle:\outerradius + 1ex) -- (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [xshift=\labelshiftdir*0.5cm,inner sep=1ex, outer sep=0pt, text width=\width,anchor=\textanchor,align=\textalign,font=\small,text=body]{\BeginAccSupp{method=pdfstringdef,ActualText={\name: \value}}\name\EndAccSupp{}};
            % Set the old cumulated angle to the new value
            \global\let\cumnum=\newcumnum
        }
      \end{scope}
%      \draw[gray] (0,0) circle (\outerradius) circle (\innerradius);
    \end{tikzpicture}\par
    \endgroup
}

\newcommand{\cvref}[3]{%
  \smallskip
  \textcolor{emphasis}{\textbf{#1}}\par
  \begin{description}[font=\color{accent},style=multiline,leftmargin=1.35em]
  \item[\normalfont\emailsymbol] #2
  \item[\small\normalfont\mailsymbol] #3
  \end{description}
%   \medskip
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

% From Santi: import "inputenc" here so it's before BibLaTeX.
\ifxetexorluatex\else
  \RequirePackage[utf8]{inputenc}
\fi

% For US-style quotes.
\RequirePackage[american]{babel}
\RequirePackage{csquotes}

\RequirePackage[backend=biber,style=mla,sorting=ymddnt,minnames=5,maxnames=9,giveninits=true,date=year,isbn=false,url=false,doi=false,eprint=false]{biblatex}

% From Santi: to order by year and month first.
% See https://tex.stackexchange.com/a/140641/56795 and https://tex.stackexchange.com/a/46879/56795
\DeclareSortingTemplate{ymddnt}{
  \sort{
    \field{presort}
  }
  \sort[final]{
    \field{sortkey}
  }
  \sort[direction=descending]{
    \field[strside=left,strwidth=4]{sortyear}
    \field[strside=left,strwidth=4]{year}
    \literal{9999}
  }
  \sort[direction=descending]{
    \field{month}
    \literal{99}
  }
  \sort[direction=descending]{
    \field{day}
    \literal{99}
  }
  \sort{
    \field{sortname}
    \field{author}
    \field{editor}
    \field{translator}
    \field{sorttitle}
    \field{title}
  }
  \sort{
    \field{sorttitle}
    \field{title}
  }
}

%% For removing numbering entirely when using a numeric style
% \setlength{\bibhang}{1em}
% \DeclareFieldFormat{labelnumberwidth}{\makebox[\bibhang][l]{\itemmarker}}
% \setlength{\biblabelsep}{0pt}
\defbibheading{pubtype}{\cvsubsection{#1}}
\renewcommand{\bibsetup}{\vspace*{-\baselineskip}}
% \AtEveryBibitem{\makebox[\bibhang][l]{\itemmarker}}
\setlength{\bibitemsep}{0.25\baselineskip}

% v1.1.2: make it easier to add a sidebar aligned with top of next page
\RequirePackage{afterpage}
\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

\AtBeginDocument{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}

\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}
\RequirePackage{hyperref}
\RequirePackage{accsupp}
\pdfstringdefDisableCommands{
  \let\\\space
}
\RequirePackage[super]{nth}

\setmainfont{Lato}

\hypersetup{colorlinks,linkcolor={cyan},citecolor={cyan},urlcolor={cyan}}

\DeclareNameAlias{author}{given-family}
\DeclareFieldFormat*{titlecase}{#1}
\DeclareFieldFormat{booktitle}{#1\nopunct} % Remove the italics.
\DeclareFieldFormat{pages}{}
\DeclareFieldFormat{url}{}
\DeclareListFormat{publisher}{}
\DeclareFieldFormat*{date}{#1\addperiod}

\AtBeginBibliography{\small}

% v1.6.5 Provide ability to highlight names in publication list
\RequirePackage{pgffor}
\def\my@namelist{}
\newcommand{\mynames}[1]{\def\my@namelist{#1}}
\newtoggle{boldname}

\newcommand{\altacv@makeboldnames}{%
  \renewcommand*{\mkbibnamefamily}[1]{%
    \global\togglefalse{boldname}%
    \ifdefempty{\my@namelist}{}{%
      \foreach \my@fname / \my@gname in \my@namelist {%
        \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                     and
                     test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
          {\global\toggletrue{boldname}}{}%
      }%
    }%
    \iftoggle{boldname}{\textbf{##1}}{##1}%
  }%
  % v1.7.4 will handle "von" "van" etc prefixes and "Jr" etc suffixes too
  \let\mkbibnamegiven\mkbibnamefamily%
  \let\mkbibnameprefix\mkbibnamefamily%
  \let\mkbibnamesuffix\mkbibnamefamily%
}

\AtBeginDocument{%
  \altacv@makeboldnames
}
