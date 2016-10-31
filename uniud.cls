%
% University of Udine Thesis LaTeX class
%
% Original file by Nicola Gigante
% modified by Marco Peressotti
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
\newbool{@candidategenderf}

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
    department/.initial=\uniudname{dima},
    department/.get=\thedepartment,
    department/.store in=\thedepartment,
%
    course/.initial=\uniudname{dima/informatica},
    course/.get=\thecourse,
    course/.store in=\thecourse,
%
	candidate name/.value required,
	candidate name/.store in=\thecandidatename,
  	candidate email/.value required,
	candidate email/.store in=\thecandidateemail,
	candidate address/.get=\thecandidateaddress,
	candidate address/.store in=\thecandidateaddress,
%
	candidate use gender/.is choice,
	candidate use gender/feminine/.code=\booltrue{@candidategenderf},
    candidate use gender/masculine/.code=\boolfalse{@candidategenderf},
%
    supervisor/.store in=\thesupervisor,
    supervisor/.value required,
%
    cosupervisor/.store in=\thecosupervisor,
%
    title/.store in=\thetitle,
    title/.value required,
%
    academic year/.store in=\theacademicyear,
    academic year/.value required,
    year/.forward to=/uniud/academic year,
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

%\mathtoolsset{showonlyrefs,showmanualtags}

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

% Common hanging space for all heading numbering
\newcommand\@lefthang[1]{\makebox[0pt][r]{#1\hspace{\marginparsep}}}

\newlength{\chaptitleheight}
\newlength{\chapnumheight}

\makechapterstyle{uniud}{%
  %\setlength\beforechapskip{0pt}
  %\setlength\midchapskip{0pt} % midskip will be ignored anyway
  \setlength\afterchapskip{50pt}
  
  \renewcommand\chapterheadstart\relax

  % Fonts and size
  \renewcommand\chaptitlefont{%
    \normalfont\fontsize{28pt}{26pt}\selectfont\scshape\raggedright%
  }
  \renewcommand\chapnumfont{%
    \normalfont\fontsize{80pt}{80pt}\selectfont\scshape%
  }

  % do not print 'chapter'
  \renewcommand\printchaptername{}
    
  % Small-caps title (always lowercase)
  \renewcommand\printchaptertitle[1]{%
  	\chaptitlefont\MakeTextLowercase{##1}%
    % record the actual height
	\settototalheight{\chaptitleheight}{\vbox{\chaptitlefont\MakeTextLowercase{##1}}}%
  }

  \renewcommand\afterchapternum{}

  \renewcommand\printchapternum{%
	\raisebox{\dimexpr-\height+12pt}[0pt][\dimexpr-\depth]{%
	  \makebox[0pt][r]{\chapnumfont\thechapter\hspace{\marginparsep}}%
	}%
	% record the actual height
	\settototalheight{\chapnumheight}{\vbox{\chapnumfont\thechapter}}%
  }
  
  \renewcommand\afterchaptertitle{\par\nobreak%
    % when needed skip some space to compensate for short titles
	\ifdim \chaptitleheight < \chapnumheight
    \vskip\dimexpr \chapnumheight - \chaptitleheight
    \fi
    \vskip\afterchapskip%
  }  
}

% 'uniud' head-style
\makeheadstyles{uniud}{%

  % Chapter style as above
  \chapterstyle{uniud}

  % Numbering up to subsections
  \setsecnumdepth{subsection}

  % Font for sections
  \setsecheadstyle{\Large\scshape\MakeTextLowercase}
  % Font for subsections
  \setsubsecheadstyle{\large}

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
\makeevenhead{uniud}{\thepage}{}{\scshape\MakeTextLowercase\leftmark}
\makeoddhead{uniud}{\scshape\MakeTextLowercase\rightmark}{}{\thepage}
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

\DeclareTranslationFallback{assumption}{assumption}
\DeclareTranslation{italian}{assumption}{assunzione}
\DeclareTranslationFallback{assumptions}{assumptions}
\DeclareTranslation{italian}{assumptions}{assunzioni}

\DeclareTranslationFallback{conjecture}{conjecture}
\DeclareTranslation{italian}{conjecture}{congettura}
\DeclareTranslationFallback{conjectures}{conjectures}
\DeclareTranslation{italian}{conjectures}{congetture}

%
% Floats, captions, theorems, cross-references, ecc...
%
\RequirePackage{amsthm}
\RequirePackage{nameref}
\RequirePackage{hyperref}
\RequirePackage[capitalise,noabbrev,nameinlink]{cleveref}
\RequirePackage{thmtools}

%
% Ensure biblatex is loaded without messing with loadtime options
%
\newbool{@BiblatexOnce}
\setbool{@BiblatexOnce}{true} 
\BeforeBeginEnvironment{document}{
	\if@BiblatexOnce
		\setbool{@BiblatexOnce}{false} 
		\RequirePackage{babel}
		\RequirePackage{csquotes}
		\RequirePackage{biblatex}
	\fi
}

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
\newcommand\@Cref@name[1]{\noexpand\noexpand\noexpand\csuse{Cref@#1@name}}
\newcommand\@cref@name[1]{\noexpand\noexpand\noexpand\csuse{cref@#1@name}}

\declaretheorem[
  name=\@cref@name{theorem},
  parent=chapter,
]{theorem}

\declaretheorem[
  name=\@cref@name{corollary},
  sibling=theorem
]{corollary}

\declaretheorem[
  name=\@cref@name{proposition},
  sibling=theorem
]{proposition}

\declaretheorem[
  name=\@cref@name{lemma},
  sibling=theorem
]{lemma}


%\crefname{conjecture}{\GetTranslation{conjecture}}{\GetTranslation{conjectures}}
\Crefname{conjecture}{\MakeCapital{\GetTranslation{conjecture}}}{\MakeCapital{\GetTranslation{conjectures}}}
\declaretheorem[
  name=\@cref@name{conjecture},
  sibling=theorem
]{conjecture}

\declaretheorem[
  name=\@cref@name{definition},
  parent=chapter,
  style=definition
]{definition}

%\crefname{assumption}{\GetTranslation{assumption}}{\GetTranslation{assumptions}}
\Crefname{assumption}{\MakeCapital{\GetTranslation{assumption}}}{\MakeCapital{\GetTranslation{assumptions}}}
\declaretheorem[
  name=\@cref@name{assumption},
  sibling=definition
]{assumption}

\declaretheorem[
  name=\@cref@name{remark},
  parent=chapter,
  style=remark,
	qed=$\triangleleft$
]{remark}

\declaretheorem[
  name=\@cref@name{example},
  sibling=remark,
	qed=$\triangleleft$
]{example}

% Continuous numbering of floats and equations
% This has to be done after the preamble to support changing it with \uniudset
\AtEndPreamble{
  \notbool{@countersbychapter}{
    \counterwithout{table}{chapter}
    \counterwithout{listing}{chapter}
    \counterwithout{equation}{chapter}
    \counterwithout{theorem}{chapter}
    \counterwithout{definition}{chapter}
  }{}
}

% Caption styling
\precaption{} %\centering
\captiondelim{.}
\captionnamefont{\scshape}
\captiontitlefont{\normalfont\small}
\captionstyle{\xspace} %\\

% Styling of theorem-like environments
\declaretheoremstyle[%
	spaceabove = 4pt,
  spacebelow = 4pt,
	postheadspace = .5em,
  headfont=\normalfont\scshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont\itshape
]{plain}

\declaretheoremstyle[
	spaceabove = 4pt,
  spacebelow = 4pt,
	postheadspace = .5em,
  headfont=\normalfont\scshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont\itshape
]{definition}

\declaretheoremstyle[
	spaceabove = 4pt,
  spacebelow = 4pt,
	postheadspace = .5em,
  headfont=\normalfont\itshape,
  notefont=\normalfont, notebraces={(}{)},
  bodyfont=\normalfont,
  headformat={\NAME{} \NUMBER \NOTE}
]{remark}



%
% Title page
%
\renewcommand\maketitle{%
  \newlength\@borders
  \setlength\@borders{2cm}
	\let\cleardoublepage\clearpage
	% cover page
  \begin{titlingpage}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
	    \begingroup%
        \makebox[0pt][l]{%
          \raisebox{-1.05\textheight}[0pt][0pt]{%
            \includegraphics[height=1.1\textheight]{graphics/mezzo-pollo-pallido.pdf}}}\hskip-0pt
      \endgroup%
      \begingroup%
	      \scshape\raggedright\Large%
	      \setlength\parskip{1ex}%
	      \uniudname{uniud}\par\vskip-4pt%
	      \uniudname{department} \thedepartment\par%
	      \if@phd%
			    \uniudname{phd}%
			  \else%
					\if@master%
					  \uniudname{master}%
					\else%
					  \uniudname{bachelor}%
					\fi%
		  	\fi%
      	\thecourse%
      \endgroup%
      \vfill%
      \begingroup%
        \scshape\raggedright
        \fontsize{36pt}{36pt}\selectfont%
        \thetitle
      \endgroup%
      \vfill%
      \begingroup%
        \scshape\raggedright%
				\normalsize%
        \if@candidategenderf%
			    \uniudname{candidate (f)}:%
			  \else%
	    		\uniudname{candidate (m)}:%
        \fi%
        \par\vskip-2pt%
        \Large%
        \thecandidatename%
        \par\vskip4pt%
        \normalsize%
        \uniudname{supervisor}:%
        \par\vskip-2pt%
        \Large%
        \thesupervisor%
        \par\vskip4pt%
        \if\pgfkeysifdefined{/uniud/cosupervisor}%
          \normalsize%
          \uniudname{cosupervisor}:%
          \par\vskip-2pt%
          \Large%
          \thecosupervisor%
          \par\vskip4pt%
        \fi%
        \normalsize%
        \uniudname{academicyear}:%
        \par\vskip-2pt%
        \Large%
        \theacademicyear%
      \endgroup%
    \end{adjustwidth*}
  \end{titlingpage}
	% cover's back
	\begin{titlingpage}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
      \begingroup%
        \raggedright%
				\normalsize%
        \thecandidateemail%
        \par\vskip4pt%
        \thecandidateaddress%
      \endgroup%
    \end{adjustwidth*}
  \end{titlingpage}
}