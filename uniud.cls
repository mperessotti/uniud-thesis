%
% University of Udine Thesis LaTeX class
%
% Original file by Nicola Gigante
% modified by Marco Peressotti
%
% This file is in the public domain
%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uniud}[%
2015/04/23 v0.1 University of Udine Thesis LaTeX Class%
]

% Basic LaTeX programming support
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{calc}

% Keyval options handling
\RequirePackage{pgfopts}

% Boolean parameters to keep track of class options
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
%
    course/.initial=\uniudname{dima/informatica},
%
		candidate name/.initial,
		candidate name/.value required,
		candidate email/.initial,
		candidate address/.initial,
%
		candidate use gender/.is choice,
		candidate use gender/feminine/.code=\booltrue{@candidategenderf},
    candidate use gender/masculine/.code=\boolfalse{@candidategenderf},
%
    supervisor/.initial,
    supervisor/.value required,
%
    cosupervisor/.initial,
%
    title/.initial,
    title/.value required,
%
    academic year/.initial,
    academic year/.value required,
    year/.forward to=/uniud/academic year,
%
		inside cover note/.initial,
%
		dedication/.initial,
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

% We are based on memoir, so let's load it
\LoadClass[a4paper,11pt]{memoir}

% uniud utility package
\RequirePackage{uniud}

% Page Layout
\checkandfixthelayout

\ifbool{@showframes}{%
  \RequirePackage{showframe}%
}{}

\setlength\parskip{0pt}
\setlength\columnsep{20pt}

%
% Fonts
%

% Charter main font, lining figures in math, osf in text
\RequirePackage[scaled=.98,sups,osf]{XCharter}
% Bera Sans sans-serif font
\RequirePackage[scaled=0.86]{berasans}
 % Inconsolata monospace font
\RequirePackage[scaled=1.03]{inconsolata}

\linespread{1.1}

\RequirePackage[
	% adjust spacing for smallcaps
	tracking=smallcaps, 
	letterspace=20
]{microtype}

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
% Floats
%

% Turn off memoir automatic reset of float counters
\renewcommand\@memfront@floats{}
\renewcommand\@memmain@floats{}
\renewcommand\@memback@floats{}

%
% Cross-references
%

\RequirePackage{nameref}
\RequirePackage{hyperref}
\RequirePackage[capitalise,noabbrev,nameinlink]{cleveref}

%
% Lists, enums, etc.
%

% Style of description labels
\renewcommand{\descriptionlabel}[1]{ %
	\hspace{\labelsep}%
	{\emph{#1}.}%
}

%
% Math
%
\RequirePackage{amsmath,amssymb}
\RequirePackage{mathtools}

%
%	theorems etc.
%

\RequirePackage{amsthm}
\RequirePackage{thmtools}

% Theorem-like environments
%  translations of these three particular names are already
%  available in cleveref so we reuse them here

% This trick is needed to defer the expansion of the cref macro until the
% typesetting point, because the macro is undefined at this point of the
% preamble
%\newcommand\@Cref@name[1]{\noexpand\noexpand\noexpand\csuse{Cref@#1@name}}
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

\declaretheorem[
  name=\@cref@name{definition},
  parent=chapter,
  style=definition
]{definition}

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
	spaceabove = .5em,
	spacebelow = .5em,
	postheadspace = .5em,
	headfont=\normalfont\scshape,
	notefont=\normalfont, notebraces={(}{)},
	bodyfont=\normalfont\itshape,
	headformat={\MakeTextLowercase{\NAME{}} \NUMBER \NOTE}
]{plain}

\declaretheoremstyle[
	spaceabove = .5em,
	spacebelow = .5em,
	postheadspace = .5em,
	headfont=\normalfont\scshape,
	notefont=\normalfont, notebraces={(}{)},
	bodyfont=\normalfont\itshape,
	headformat={\MakeTextLowercase{\NAME{}} \NUMBER \NOTE}
]{definition}

\declaretheoremstyle[
	spaceabove = .5em,
	spacebelow = .5em,
	postheadspace = .5em,
	headfont=\normalfont\scshape,
	notefont=\normalfont, notebraces={(}{)},
	bodyfont=\normalfont,
	headformat={\MakeTextLowercase{\NAME{}} \NUMBER \NOTE}
]{remark}

% redefine ams proof environment to match the style used for theorems etc.

\renewenvironment{proof}[1][\proofname] {\par\pushQED{\qed}\normalfont\topsep6\p@\@plus6\p@\relax\trivlist\item[\hskip\labelsep\normalfont\scshape\MakeTextLowercase{#1}\@addpunct{.}]\ignorespaces}{\popQED\endtrivlist\@endpefalse}

%-------------------------------------------------------------------------------
%	COVER
%-------------------------------------------------------------------------------

\renewcommand\maketitle{%
  \newlength\@borders
  \setlength\@borders{2cm}
  \let\oldcleardoublepage\cleardoublepage
  \let\cleardoublepage\clearpage
	\def\scLarge{\fontsize{15pt}{14.4pt}\selectfont}
	\def\scnormal{\fontsize{12.0pt}{11pt}\selectfont}
	\def\blockskip{\vskip4pt}
  % cover page
  \begin{titlingpage}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
	    \begingroup%
        \makebox[0pt][l]{%
          \raisebox{-1.05\textheight}[0pt][0pt]{%
            \includegraphics[draft=false,height=1.1\textheight]{graphics/mezzo-pollo-pallido.pdf}}}\hskip-0pt
      \endgroup%
      \begingroup%
        \raggedright\scshape%
				\scLarge%
	      \uniudname*{uniud}\par%
	      \uniudname*{department} \pgfkeysvalueof{/uniud/department}\par%
	      \if@phd%
          \uniudname*{phd}
			  \else%
					\if@master%
					  \uniudname*{master}
					\else%
					  \uniudname*{bachelor}
					\fi%
		  	\fi%
      	\MakeTextLowercase{\pgfkeysvalueof{/uniud/course}}\par
      \endgroup%
      \vfill%
      \begingroup%
        \scshape\raggedright%
        \fontsize{36pt}{30pt}\selectfont%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/title}}\par
      \endgroup%
      \vfill%
      \begingroup%
	      \scshape\raggedright%
				\scnormal%
        \if@candidategenderf%
			    \uniudname*{candidate (f)}:%
			  \else%
	    		\uniudname*{candidate (m)}:%
        \fi%
				\scLarge\par%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/candidate name}}%
				\blockskip%
				\scnormal\par%
        \uniudname*{supervisor}:%
				\scLarge\par%
        \MakeTextLowercase{\pgfkeysvalueof{/uniud/supervisor}}%
				\if\pgfkeysvalueof{/uniud/cosupervisor}\empty\else%
					\blockskip%
					\scnormal\par%
          \uniudname*{cosupervisor}:%
	        \scLarge\par%
          \MakeTextLowercase{\pgfkeysvalueof{/uniud/cosupervisor}}%
        \fi%
				\blockskip%
				\scnormal\par%
        \uniudname*{academicyear}:%
        \scLarge\par%
        \MakeTextLowercase{\pgfkeysvalueof{/uniud/academic year}}%
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
 				\if\pgfkeysvalueof{/uniud/candidate email}\empty\else%
	        \pgfkeysvalueof{/uniud/candidate email}%
	        \par\vskip4pt%
				\fi%
				\if\pgfkeysvalueof{/uniud/candidate address}\empty\else%
          \pgfkeysvalueof{/uniud/candidate address}%
	        \par\vskip4pt%
				\fi%
        \if\pgfkeysvalueof{/uniud/inside cover note}\empty\else%
          \vskip4pt%
          \pgfkeysvalueof{/uniud/inside cover note}%
	        \par\vskip4pt%
				\fi%
      \endgroup%
    \end{adjustwidth*}
  \end{titlingpage}
	% dedication page
	\if\pgfkeysvalueof{/uniud/dedication}\empty\else%
		\clearpage
		\par\vspace*{.35\textheight}{\centering\small\pgfkeysvalueof{/uniud/dedication}\par}
		\thispagestyle{empty}
	\fi
  % restore \cleardoublepage expected behaviour
  \let\cleardoublepage\oldcleardoublepage
}

%-------------------------------------------------------------------------------
%	SUPPORT FOR OPTIONAL PACKAGES
%-------------------------------------------------------------------------------

%
% BIBLATEX
%
\AtEndPreamble{
	\@ifpackageloaded{biblatex}{
	
		\RequirePackage{csquotes}
			
		\defbibheading{bibliography}{%
			\chapter*{#1}%
			\addcontentsline{toc}{chapter}{#1}
			\markboth{#1}{#1}
		}
	}{}
}

%
% LISTINGS
%
\AtEndPreamble{
\@ifpackageloaded{listings}{

% translations
\DeclareTranslationFallback {listing}{Listing}
\DeclareTranslation{Italian}{listing}{Listato}
\DeclareTranslationFallback {listings}{Listings}
\DeclareTranslation{Italian}{listings}{Listati}

% 'listing' floating environment
\newfloat[chapter]{listing}{lol}{\GetTranslation{listing}}
\crefname{listing}{\GetTranslation{listing}}{\GetTranslation{listings}}

% Continuous numbering
\notbool{@countersbychapter}{
  \counterwithout{listing}{chapter}
}{}

}{}}