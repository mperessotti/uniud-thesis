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
\RequirePackage{xstring}
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
\newbool{@pdfmetadata}

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
    logo/.initial={graphics/pollo.pdf},
		logo/.get = \@logopath,
%
    department/.initial=\uniudname{dima},
%
    course/.initial=\uniudname{dima/informatica},
%
		candidate name/.initial,
		candidate email/.initial,
		candidate address/.initial,
%
		candidate use gender/.is choice,
		candidate use gender/feminine/.code=\booltrue{@candidategenderf},
    candidate use gender/masculine/.code=\boolfalse{@candidategenderf},
%
    supervisor/.initial,
%
    cosupervisors/.initial,
		cosupervisor/.style={cosupervisors={#1}},
%
    title/.initial,
%
    subtitle/.initial,
%
    academic year/.initial,
    year/.forward to=/uniud/academic year,
		phd cycle/.initial,
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
    countersbychapter/.forward to=/uniud/counters by chapter,
%
		pdfmetadata/.is if=@pdfmetadata,
		pdfmetadata/.initial=true,
}

% Command to set uniud options
\newcommand\uniudset[1]{\pgfqkeys{/uniud}{#1}}

% Process class options
\ProcessPgfOptions{/uniud}

% We are based on memoir, so let's load it
\LoadClass[a4paper,11pt]{memoir}

% uniud utility package
\RequirePackage{uniud}

% Option validation
\newcommand{\@CheckRequiredOpt}[2][]{%
	\ifx\pgfkeysvalueof{/uniud/#2}\empty
	    \ClassError{uniud}{Option '#2' is required}{#1}
	\fi
}
\AtEndPreamble{
	\@CheckRequiredOpt{title}
	\@CheckRequiredOpt{supervisor}
	\@CheckRequiredOpt{candidate name}
	\if@phd%
	  % 'cycle' is required for bachelor and master thesis
	 	\@CheckRequiredOpt{phd cycle}
	\else
	 	% 'academic year' is required for bachelor and master thesis
		\@CheckRequiredOpt{academic year}
	\fi	
}

% pdf setup
\if@pdfmetadata
\AtEndPreamble{
	\hypersetup{
	  pdftitle={\pgfkeysvalueof{/uniud/title}},
	  pdfauthor={\pgfkeysvalueof{/uniud/candidate name}},
	}
}
\fi

% Page Layout
\checkandfixthelayout

\ifbool{@showframes}{%
  \RequirePackage{showframe}%
}{}

\setlength\parskip{0pt}

% Two columns layout
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
% Customization of \marginpar. 
% Put here because it is needed for paragraph head style
%
\let\@oldmarginpar\marginpar
\RenewDocumentCommand{\marginpar}{o m}{%
  \@oldmarginpar%
    [\itshape\raggedleft\IfValueTF{#1}{#1}{#2}]%
    {\itshape\raggedright#2}%
}

%
% head style
%

% 'uniud' chapter style

% Common hanging space for all heading numbering
\newcommand\@lefthang[1]{\makebox[0pt][r]{#1\hspace{\marginparsep}}}

\makechapterstyle{uniud}{%
  %\setlength\beforechapskip{0pt}
  %\setlength\midchapskip{0pt} % midskip will be ignored anyway
  \setlength\afterchapskip{50pt}
  
  \renewcommand\chapterheadstart\relax
	
	% some aux lengths
	\newlength{\@chaptitleheight}
	\newlength{\@chapnumheight}

  % Fonts and size
  \renewcommand{\chaptitlefont}{%
    \normalfont\fontsize{28pt}{26pt}\selectfont\scshape\raggedright%
  }
  \renewcommand{\chapnumfont}{%
    \normalfont\fontsize{80pt}{80pt}\selectfont\scshape%
  }

  % do not print 'chapter'
  \renewcommand{\printchaptername}{}
    
  % Small-caps title (always lowercase)
  \renewcommand{\printchaptertitle}[1]{%
  	\chaptitlefont\MakeTextLowercase{##1}%
    % record the actual height
		\settototalheight{\@chaptitleheight}{\vbox{\chaptitlefont\MakeTextLowercase{##1}}}%
  }
	
  \renewcommand\afterchapternum{}

  \renewcommand\printchapternum{%
		\raisebox{\dimexpr-\height+12pt}[0pt][\dimexpr-\depth]{%
		  \makebox[0pt][r]{\chapnumfont\thechapter\hspace{\marginparsep}}%
		}%
		% record the actual height
		\settototalheight{\@chapnumheight}{\vbox{\chapnumfont\thechapter}}%
  }
  
  \renewcommand\afterchaptertitle{\par\nobreak%
    % when needed skip some space to compensate for short titles
		\ifdim \@chaptitleheight < \@chapnumheight
	    \vskip\dimexpr \@chapnumheight - \@chaptitleheight
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
	
	% Book style
	% disable page numbers and headers
	\aliaspagestyle{book}{empty}
	% Fonts and size
	\renewcommand{\booktitlefont}{%
		\normalfont\fontsize{28pt}{26pt}\selectfont\scshape%
	}
	\renewcommand{\booknamefont}{%
		\normalfont\fontsize{15pt}{14.4pt}\selectfont\scshape%
	}
	\renewcommand{\booknumfont}{%
		\normalfont\fontsize{80pt}{80pt}\selectfont\scshape%
	}
	% print 'book' above book number
	\renewcommand{\printbookname}{
		\booknamefont\MakeTextLowercase{\bookname}\par\vspace{-1\onelineskip}%
	}
	\renewcommand{\midbookskip}{\par\vspace{1\onelineskip}}
	% Small-caps title (always lowercase)
	\renewcommand{\printbooktitle}[1]{%
		\booktitlefont\MakeTextLowercase{##1}%
	}
	
	% Part style		
	% disable page numbers and headers
	\aliaspagestyle{part}{empty}
	% Fonts and size
	\renewcommand{\parttitlefont}{%
		\normalfont\fontsize{28pt}{26pt}\selectfont\scshape%
	}
	\renewcommand{\partnamefont}{%
		\normalfont\fontsize{15pt}{14.4pt}\selectfont\scshape%
	}
	\renewcommand{\partnumfont}{%
		\normalfont\fontsize{80pt}{80pt}\selectfont\scshape%
	}
	% print 'part' above number
	\renewcommand{\printpartname}{
		\partnamefont\MakeTextLowercase{\partname}\par\vspace{-1\onelineskip}%
	}
	\renewcommand{\midpartskip}{\par\vspace{1\onelineskip}}
	% Small-caps title (always lowercase)
	\renewcommand{\printparttitle}[1]{%
		\parttitlefont\MakeTextLowercase{##1}%
	}
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
% TOC
%
\setcounter{tocdepth}{2}
\renewcommand{\cftbookfont}{\normalfont}
\renewcommand{\cftbookpagefont}{\normalfont} 
\renewcommand{\cftpartfont}{\normalfont}
\renewcommand{\cftpartpagefont}{\normalfont} 
\renewcommand{\cftchapterfont}{\normalfont}  
\renewcommand{\cftchapterpagefont}{\normalfont} 

%
% Acknowledgements
%
\DeclareTranslationFallback{acknowledgements}{Acknowledgements}
\DeclareTranslation{Italian}{acknowledgements}{Ringraziamenti}

\newbool{@addacktotoc}
\boolfalse{@addacktotoc}
\newcommand\acknowledgementsintoc{\booltrue{@addacktotoc}}
\newenvironment{acknowledgements}{
	\if@mainmatter
		\ClassError{Uniud}{Acknowledgements cannot be used in the main matter.}	
	\else
		\if@addacktotoc
			\chapter{\GetTranslation{acknowledgements}}
		\else
			\chapter*{\GetTranslation{acknowledgements}}
		\fi
	\fi
}{\cleardoublepage}

%
% Abstract
%
\renewenvironment{abstract}{
	\if@mainmatter
		\ClassError{Uniud}{Abstract cannot be used in the main matter.}	
	\else
		\chapter*{\abstractname}
		% use memoir's handling of abstract and toc instead
		\put@bsintoc
	\fi
}{\cleardoublepage}

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
	\def\scnormal{\fontsize{12.0pt}{11.5pt}\selectfont}
	\def\blockskip{\vskip4pt}
  % cover page
  \begin{titlingpage}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
			\centering
      \begingroup%
        \scshape%
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
			\vskip-1.5cm%
			\includegraphics[draft=false,height=3cm]{\@logopath}
			\vskip-1.5cm%
      \vfill%
      \begingroup%
        \scshape%
				\scnormal%
				\uniudname*{dissertation}
				\bigskip%
				\par%
        \fontsize{30pt}{22pt}\selectfont%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/title}}\par%
				\if\pgfkeysvalueof{/uniud/subtitle}\empty\else%
					\medskip%
					\fontsize{24pt}{20pt}\selectfont%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/subtitle}}\par%
				\fi
      \endgroup%
			\vfill%
      \begingroup%
			  \newlength\tpbox@width
			  \setlength\tpbox@width{\dimexpr.5\textwidth-.5\columnsep}
				\parbox[t]{\tpbox@width}{%
					\centering\scshape\scnormal%
					\if@candidategenderf%
						\uniudname*{candidate (f)}%
					\else%
						\uniudname*{candidate (m)}%
					\fi%
					\scLarge\par%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/candidate name}}%
				}\hfill\parbox[t]{\tpbox@width}{%
					\centering\scshape\scnormal%
					\uniudname*{supervisor}%
					\scLarge\par%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/supervisor}}%
					\if\pgfkeysvalueof{/uniud/cosupervisors}\empty\else
						\par\bigskip%
						\centering\scshape\scnormal%
						\edef\@supervisors{\pgfkeysvalueof{/uniud/cosupervisors}}%
						\StrCount{\@supervisors}{,}[\@numcosupervisors]
						\ifnum\@numcosupervisors>0\relax
					  	\uniudname*{cosupervisors}%
						\else%
							\uniudname*{cosupervisor}%
						\fi%
					  \scLarge%
						\foreach \name in \@supervisors{%
					  	\par\MakeTextLowercase{\name}%
						}%
					\fi
				}
			\endgroup%
			\vfill%
			\begingroup%
	      \scshape%
				\if@phd%
					\scnormal\par%
					\uniudname*{phdcycle}%
					\scLarge\par%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/phd cycle}}%
				\fi
				\if\pgfkeysvalueof{/uniud/academic year}\empty\else
					\if@phd\smallskip\fi%
						\scnormal\par%
		        \uniudname*{academicyear}%
		        \scLarge\par%
		        \MakeTextLowercase{\pgfkeysvalueof{/uniud/academic year}}%
				\fi
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
