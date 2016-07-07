%
% University of Udine
% Thesis LaTeX class
%
% Copyright (C) 2015 Nicola Gigante
%
% This file is in the public domain
%
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uniud}[2015/04/23 v0.1 University of Udine Thesis LaTeX Class]

%
% Basic LaTeX programming support
%
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{calc}

% Keyval options handling
\RequirePackage{pgfopts}

%
% Boolean parameters to keep track of class options
%

\newbool{@bachelor}
\newbool{@master}
\newbool{@phd}
\newbool{@showframes}
\newbool{@countersbychapter}

% Declare class options
\pgfkeys{
  /uniud/.is family,
  /uniud,
    degree/.is choice,
    degree/.value required,
    degree/.cd,
      bachelor/.is if=@bachelor,
      master/.is if=@master,
      phd/.is if=@phd,
  /uniud,
    bachelor/.style={degree=bachelor},
    master/.style={degree=master},
    phd/.style={degree=phd},
%
    department/.code={\department{#1}},
    course/.code={\course{#1}},
    author/.code={\author{#1}},
    supervisor/.code={\supervisor{#1}},
    cosupervisor/.code={\cosupervisor{#1}},
    title/.code={\title{#1}},
%
    showframes/.is if=@showframes,
    showframes/.initial=false,
%
    counters by chapter/.is if=@countersbychapter,
    counters by chapter/.initial=false,
    countersbychapter/.forward to=/uniud/counters by chapter
}

% Command to set uniud options
\newcommand\uniudset[1]{\pgfqkeys{/uniud}{#1}}

% Process class options
\ProcessPgfOptions{/uniud}

%
% We are based on memoir, so let's load it
%
\LoadClass[a4paper,11pt]{memoir}

%
% uniud utility package
%
\RequirePackage{uniud}

%
% Page Layout
%
\checkandfixthelayout

\ifbool{@showframes}{%
  \RequirePackage{showframe}%
}{}

\setlength\parskip{0pt}

%
% Fonts
%
% Charter main font, lining figures in math, osf in text
\RequirePackage[scaled=.98,sups,osf]{XCharter}
\RequirePackage[scaled=0.86]{berasans}    % Bera Sans sans-serif font
\RequirePackage[scaled=1.03]{inconsolata} % Inconsolata monospace font


%
% Math
%
\RequirePackage{amsmath,amssymb}
\RequirePackage{mathtools}

\mathtoolsset{showonlyrefs,showmanualtags}

%
% Customization of \marginpar. Put here because it is needed for paragraph
% head style
%
\let\@oldmarginpar\marginpar
\RenewDocumentCommand{\marginpar}{o m}{%
  \@oldmarginpar%
    [\itshape\raggedleft\IfValueTF{#1}{#1}{#2}]%
    {\itshape\raggedright#2}%
}

%
% Head styles
%

% 'uniud' chapter-style
\makechapterstyle{uniud}{%
  % Minimize vertical spaces
  \setlength\afterchapskip{50pt}
  \setlength\midchapskip{0pt}
  \renewcommand\chapterheadstart\relax

  % We don't print "Chapter"
  \renewcommand\printchaptername{}

  % Fonts and size
  \renewcommand\chaptitlefont{%
    \normalfont\fontsize{28pt}{26pt}\selectfont\scshape\raggedright%
  }
  \renewcommand\chapnumfont{%
    \normalfont\fontsize{80pt}{80pt}\selectfont\scshape%
  }

  % Small-caps title (always lowercase)
  \renewcommand\printchaptertitle[1]{\chaptitlefont\MakeTextLowercase{##1}}
}

% Common hanging space for all heading numbering
\newcommand\@lefthang[1]{\makebox[0pt][r]{#1\hspace{\marginparsep}}}

% 'uniud' head-style
\makeheadstyles{uniud}{%

  % Chapter style as above
  \chapterstyle{uniud}

  % Numbering up to subsections
  \setsecnumdepth{subsection}

  % Font for sections
  \setsecheadstyle{\Large\scshape\MakeTextLowercase}
  % Font for subsections
  \setsubsecheadstyle{\large\itshape}

  % Font for subsubsections
  \setsubsubsecheadstyle{\scshape\MakeTextLowercase}

  % Numbers hanging on the margin
  \setsecnumformat{\@lefthang{\csuse{the##1}}}

  % Italic paragraphs and subparagraphs
  \setparaheadstyle{\normalfont\itshape}
  \setsubparaheadstyle{\normalfont\itshape}
}

\headstyles{uniud}

%
% Page headers
%
% Remove footer from the chapter and title pagestyle
\copypagestyle{chapter}{empty}
\copypagestyle{titlingpage}{empty}

\makepagestyle{uniud}
\makeevenhead{uniud}{\thepage}{}{\scshape\leftmark}
\makeoddhead{uniud}{\scshape\rightmark}{}{\thepage}
\makeoddfoot{uniud}{}{}{}
\makeevenfoot{uniud}{}{}{}

\makepsmarks{uniud}{%
  \renewcommand*{\chaptermark}[1]{\markboth{\thechapter. ##1}{\rightmark}}
  \renewcommand*{\sectionmark}[1]{\markright{\@lefthang{\thesection}##1}}
}

\pagestyle{uniud}

%
% Translatable strings
%
\DeclareTranslationFallback {listing} {Listing}
\DeclareTranslation{Italian}{listing} {Listato}
\DeclareTranslationFallback {listings}{Listings}
\DeclareTranslation{Italian}{listings}{Listati}

%
% Floats, captions, theorems, cross-references, ecc...
%
\RequirePackage{amsthm}
\RequirePackage{nameref}
\RequirePackage{hyperref}
\RequirePackage[capitalise,noabbrev,nameinlink]{cleveref}
\RequirePackage{thmtools}

% Turn off memoir automatic reset of float counters
\renewcommand\@memfront@floats{}
\renewcommand\@memmain@floats{}
\renewcommand\@memback@floats{}

% 'listing' floating environment
\newfloat[chapter]{listing}{lol}{\GetTranslation{listing}}
\crefname{listing}{\GetTranslation{listing}}{\GetTranslation{listings}}

% Theorem-like environments
%  translations of these three particular names are already
%  available in cleveref so we reuse them here

% This trick is needed to defer the expansion of the cref macro until the
% typesetting point, because the macro is undefined at this point of the
% preamble
\newcommand\@cref@name[1]{\noexpand\noexpand\noexpand\csuse{cref@#1@name}}

\declaretheorem[
  name=\@cref@name{theorem},
  parent=chapter,
]{theorem}

\declaretheorem[
  name=\@cref@name{lemma},
  sibling=theorem
]{lemma}

\declaretheorem[
  name=\@cref@name{definition},
  parent=chapter,
  style=definition
]{definition}

\declaretheorem[
  name=\@cref@name{corollary},
  parent=chapter,
  style=remark
]{corollary}

% Continuous numbering of floats and equations
% This has to be done after the preamble to support changing it with \uniudset
\AtEndPreamble{
  \notbool{@countersbychapter}{
    \counterwithout{table}{chapter}
    \counterwithout{listing}{chapter}
    \counterwithout{equation}{chapter}
    \counterwithout{theorem}{chapter}
    \counterwithout{lemma}{chapter}
    \counterwithout{definition}{chapter}
    \counterwithout{corollary}{chapter}
  }{}
}

% Caption styling
\precaption{\centering}
\captiondelim{}
\captionnamefont{\scshape}
\captiontitlefont{\normalfont\itshape}
\captionstyle{\\}

% Styling of theorem-like environments
\declaretheoremstyle[%
  headfont=\normalfont\scshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont\itshape
]{plain}

\declaretheoremstyle[
  headfont=\normalfont\scshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont\itshape
]{definition}

\declaretheoremstyle[
  headfont=\normalfont\itshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont,
  headformat={\NAME{} \NUMBER \NOTE}
]{remark}


%
% Title page
%
\newcommand\thedepartment{}
\newcommand\thecourse{}
\newcommand\theauthor{}
\newcommand\thesupervisor{}
\newcommand\thecosupervisor{}
\newcommand\thetitle{}

\newcommand\department[1]{\renewcommand\thedepartment{#1}}
\newcommand\course[1]{\renewcommand\thecourse{#1}}
\renewcommand\author[1]{\renewcommand\theauthor{#1}}
\newcommand\supervisor[1]{\renewcommand\thesupervisor{#1}}
\newcommand\cosupervisor[1]{\renewcommand\thecosupervisor{#1}}
\renewcommand\title[1]{\renewcommand\thetitle{#1}}

\RequirePackage{lipsum}

\renewcommand\maketitle{%
  \newlength\@borders
  \setlength\@borders{3cm}
  \begin{titlingpage}
    \calccentering{\unitlength}
      \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}
        \begingroup
          \centering
          \includegraphics[width=5cm]{graphics/pollo.pdf}
        \endgroup

        \begingroup
          \par
          \scshape\LARGE
          \raggedright
          \setlength\parskip{2ex}
          \uniudname{uniud}
          \par\uniudname{dima}
          \par\uniudname{master}\\\uniudname{dima/informatica}
        \endgroup
      \end{adjustwidth*}
  \end{titlingpage}
}
