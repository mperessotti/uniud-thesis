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

%-------------------------------------------------------------------------------
%	OPTIONS
%-------------------------------------------------------------------------------

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

%
% The following code provides the two handlers:
% 	.initial without value
%		.unset.
%
\def\pgfkeys@@notset{\PackageError{pgfkeys}
  {The \pgfkeyscurrentpath\space key has not been set to a value.}{}}
\begingroup
  \lccode`\Q=`\-
  \lccode`\N=`\N
  \lccode`\V=`\V
  \lowercase{\endgroup
    \def\pgfkeys@notset{QNoValue-\pgfkeys@@notset}}
\pgfqkeys{/handlers}{%
  .initial without value/.code/.expand once={%
	  \expandafter\pgfkeyssetvalue\expandafter{\expandafter\pgfkeyscurrentpath\expandafter}\expandafter{\pgfkeys@notset}%
  },
  .unset/.code={
    \pgfkeysifdefined{\pgfkeyscurrentpath}{
	    \pgfkeys{\pgfkeyscurrentpath/.initial without value}
	  }{
		  \PackageError{pgfkeys}{The \pgfkeyscurrentpath\space key has not been initialized.}{}
		}
	}
}

\newcommand{\IfKeySetByUserTF}[3]{%
	\expandafter\ifx\csname pgfk@#1\endcsname\pgfkeys@notset%
		#3%
	\else%
		#2%
	\fi%
}
\newcommand{\IfKeySetByUserT}[2]{\IfKeySetByUserTF{#1}{#2}{}}
\newcommand{\IfKeySetByUserF}[2]{\IfKeySetByUserTF{#1}{}{#2}}

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
% 
		bachelor/.style={degree=bachelor},
		master/.style={degree=master},
		phd/.style={degree=phd},
%
		logo/.initial without value,
		logo height/.initial without value,
%
		affiliation/.initial without value,
%
		institution/.code/.expand once={
			% set this key
			\pgfkeyssetvalue{/uniud/institution}{#1}
			% update 'affiliation'
			\updateAffiliation
		},
%
		faculty/.code/.expand once={
			% update this key
			\pgfkeyssetvalue{/uniud/faculty}{\GetTranslation{facultyof} #1}
			% update 'affiliation'
			\updateAffiliation
		},
%
		school/.code/.expand once={
			% update this key
			\pgfkeyssetvalue{/uniud/school}{\GetTranslation{schoolof} #1}
			% update 'affiliation'
			\updateAffiliation
		},
%
		department/.code/.expand once={
			% update this key
			\pgfkeyssetvalue{/uniud/department}{\GetTranslation{departmentof} #1}
			% update 'affiliation'
			\updateAffiliation
		},
%
		laboratory/.code/.expand once={
			% update this key
			\pgfkeyssetvalue{/uniud/laboratory}{\GetTranslation{laboratoryof} #1}
			% update 'affiliation'
			\updateAffiliation
		},
%
    course/.initial without value,
%
		candidate name/.initial without value,
		candidate email/.initial without value,
		candidate address/.initial without value,
%
		candidate use gender/.is choice,
		candidate use gender/feminine/.code=\booltrue{@candidategenderf},
    candidate use gender/masculine/.code=\boolfalse{@candidategenderf},
%
    supervisor/.initial without value,
%
    cosupervisors/.initial={},
		cosupervisor/.style={cosupervisors={#1}},
%
    title/.initial without value,
%
    subtitle/.initial without value,
%
    academic year/.initial without value,
		phd cycle/.initial without value,
%
		inside cover note/.initial without value,
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

% An helper for updating 'affiliation' key
\newcommand\updateAffiliation{%
	\pgfkeys{/uniud/affiliation={%
		\pgfkeysvalueof{/uniud/institution},%
		\pgfkeysvalueof{/uniud/faculty},%
		\pgfkeysvalueof{/uniud/school},%
		\pgfkeysvalueof{/uniud/department},%
		\pgfkeysvalueof{/uniud/laboratory},%
	}}}

% Option validation
\newcommand\@CheckRequiredOpt[2][Options can be set by means of \noexpand\uniudset]{%
	\IfKeySetByUserF{/uniud/#2}{
	    \ClassError{uniud}{Option '#2' is required}{#1}
	}}
\newcommand{\uniud@ValidateOptions}{
	% check if the macro is expanded after the preamble
	\ifx\@onlypreamble\@notprerr
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
		\@CheckRequiredOpt{course}
		\@CheckRequiredOpt{affiliation}
	\fi
}
\AfterEndPreamble{\uniud@ValidateOptions}

% Command to set uniud options
\NewDocumentCommand{\uniudset}{s +m}{
	\pgfqkeys{/uniud}{#2}
	\IfBooleanF{#1}{%
		% check option consistency
		\uniud@ValidateOptions
	}
}

% Process class options
\ProcessPgfOptions{/uniud}

% We are based on memoir, so let's load it
\LoadClass[a4paper,11pt]{memoir}

% uniud utility package
%\RequirePackage{uniud}

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
% Dedication
%
\newenvironment{dedication}{
	\clearpage
 	\thispagestyle{empty}
 	\par\vspace*{.35\textheight}%
	\centering\small%
}{\cleardoublepage}



%
% Acknowledgements
%
\newbool{@addacktotoc}
\boolfalse{@addacktotoc}
\newcommand\acknowledgementsintoc{\booltrue{@addacktotoc}}
\newenvironment{acknowledgements}{
	\if@mainmatter
		\ClassError{Uniud}{Acknowledgements cannot be used in the main matter.}{}	
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
		\ClassError{Uniud}{Abstract cannot be used in the main matter.}{}	
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
\RequirePackage[hypertexnames=false]{hyperref}
\RequirePackage[capitalise,noabbrev,nameinlink]{cleveref}
%\RequirePackage{autonum}
%\if@cref@capitalise

% pdf setup
\if@pdfmetadata
\AtEndPreamble{
	\hypersetup{
	  pdftitle={\pgfkeysvalueof{/uniud/title}},
	  pdfauthor={\pgfkeysvalueof{/uniud/candidate name}},
	}
}
\fi

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
  style=remark
]{remark}

\declaretheorem[
  name=\@cref@name{remark},
  parent=chapter,
  style=remark
]{note}

\declaretheorem[
  name=\@cref@name{example},
  sibling=remark
]{example}

% Continuous numbering of floats and equations
% This has to be done after the preamble to support changing it with \uniudset
\AtEndPreamble{
  \notbool{@countersbychapter}{
    \counterwithout{table}{chapter}
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
	headformat={\MakeTextLowercase{\expandafter\NAME{}} \NUMBER \NOTE}
]{plain}

\declaretheoremstyle[
	spaceabove = .5em,
	spacebelow = .5em,
	postheadspace = .5em,
	headfont=\normalfont\scshape,
	notefont=\normalfont, notebraces={(}{)},
	bodyfont=\normalfont\itshape,
	headformat={\MakeTextLowercase{\expandafter\NAME{}} \NUMBER \NOTE}
]{definition}

\declaretheoremstyle[
	spaceabove = .5em,
	spacebelow = .5em,
	postheadspace = .5em,
	headfont=\normalfont\scshape,
	notefont=\normalfont, notebraces={(}{)},
	bodyfont=\normalfont,
	headformat={\MakeTextLowercase{\expandafter\NAME{}} \NUMBER \NOTE},,
	qed={$\triangleleft$}
]{remark}

% redefine ams proof environment to match the style used for theorems etc.
\renewenvironment{proof}[1][\proofname] {\par\pushQED{\qed}\normalfont\topsep6\p@\@plus6\p@\relax\trivlist\item[\hskip\labelsep\normalfont\scshape\MakeTextLowercase{#1}\@addpunct{.}]\ignorespaces}{\popQED\endtrivlist\@endpefalse}

%-------------------------------------------------------------------------------
%	LOCALIZATION
%-------------------------------------------------------------------------------
\RequirePackage{translations}

\DeclareTranslationFallback {bachelorin}{Bachelor Degree in}
\DeclareTranslation{Italian}{bachelorin}{Corso di Laurea Triennale in}

\DeclareTranslationFallback {masterin}{Master Degree in}
\DeclareTranslation{Italian}{masterin}{Corso di Laurea Magistrale in}

\DeclareTranslationFallback {phdin}{Ph.D. in}
\DeclareTranslation{Italian}{phdin}{Dottorato di Ricerca in}

\DeclareTranslationFallback {dissertation}{Dissertation}
\DeclareTranslation{Italian}{dissertation}{Dissertazione}

\DeclareTranslationFallback {facultyof}{Faculty of}
\DeclareTranslation{Italian}{facultyof}{Facolt\'a di}

\DeclareTranslationFallback {schoolof}{School of}
\DeclareTranslation{Italian}{schoolof}{Scuola di}

\DeclareTranslationFallback {departmentof}{Department of}
\DeclareTranslation{Italian}{departmentof}{Dipartimento di}

\DeclareTranslationFallback {laboratoryof}{Laboratory of}
\DeclareTranslation{Italian}{laboratoryof}{Laboratorio di}

\DeclareTranslationFallback {academicyear}{Academic year}
\DeclareTranslation{Italian}{academicyear}{Anno accademico}

\DeclareTranslationFallback {phdcycle}{Cycle}
\DeclareTranslation{Italian}{phdcycle}{Ciclo}

\DeclareTranslationFallback {supervisor}{Supervisor}
\DeclareTranslation{Italian}{supervisor}{Supervisore}

\DeclareTranslationFallback {cosupervisor}{Co-supervisor}
\DeclareTranslation{Italian}{cosupervisor}{Co-supervisore}
\DeclareTranslationFallback {cosupervisors}{Co-supervisors}
\DeclareTranslation{Italian}{cosupervisors}{Co-supervisori}

\DeclareTranslationFallback {candidate (f)}{Candidate}
\DeclareTranslationFallback {candidate (m)}{Candidate}
\DeclareTranslation{Italian}{candidate (f)}{Candidata}
\DeclareTranslation{Italian}{candidate (m)}{Candidato}

\DeclareTranslationFallback {acknowledgements}{Acknowledgements}
\DeclareTranslation{Italian}{acknowledgements}{Ringraziamenti}

%-------------------------------------------------------------------------------
%	COVER
%-------------------------------------------------------------------------------
\RequirePackage{xstring}

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
		\newlength\tpbox@width
		\setlength\tpbox@width{\dimexpr.5\textwidth-.5\columnsep}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
			\centering
      \begingroup%
        \scshape%
				\scLarge%
				\edef\uniud@affiliation{\pgfkeysvalueof{/uniud/affiliation}}
				\foreach \line in \uniud@affiliation{%
					\MakeTextLowercase{\line}\par%
				}%
	      \if@phd%
          \GetLCTranslation{phdin}
			  \else%
					\if@master%
					  \GetLCTranslation{masterin}
					\else%
					  \GetLCTranslation{bachelorin}
					\fi%
		  	\fi%
      	\MakeTextLowercase{\pgfkeysvalueof{/uniud/course}}\par
      \endgroup%
			\vfill%
			\IfKeySetByUserT{/uniud/logo}{%
				\newlength\uniud@logo@height%
				\IfKeySetByUserTF{/uniud/logo height}{%
					\setlength\expandafter\pgfkeysvalueof{/uniud/logo height}%
				}{%
					\setlength\uniud@logo@height{3cm}%
				}%
				\vskip-.5\uniud@logo@height%
				\edef\uniud@logopath{\pgfkeysvalueof{/uniud/logo}}
				\includegraphics[draft=false,height=\uniud@logo@height]{\uniud@logopath}
				\vskip-.5\uniud@logo@height%
			}
      \vfill%
      \begingroup%
        \scshape%
				\scnormal%
				\GetLCTranslation{dissertation}
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
			% candidate, supercisor, cosupervisors
      \begingroup%
				\parbox[t]{\tpbox@width}{%
					\centering\scshape\scnormal%
					\if@candidategenderf%
						\GetLCTranslation{candidate (f)}%
					\else%
						\GetLCTranslation{candidate (m)}%
					\fi%
					\scLarge\par%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/candidate name}}%
				}\hfill\parbox[t]{\tpbox@width}{%
					\centering\scshape\scnormal%
					\GetLCTranslation{supervisor}%
					\scLarge\par%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/supervisor}}%
					\if\pgfkeysvalueof{/uniud/cosupervisors}\empty\else
						\par\bigskip%
						\centering\scshape\scnormal%
						\edef\uniud@supervisors{\pgfkeysvalueof{/uniud/cosupervisors}}%
						\StrCount{\uniud@supervisors}{,}[\uniud@numcosupervisors]
						\ifnum\uniud@numcosupervisors>0\relax
					  	\GetLCTranslation{cosupervisors}%
						\else%
							\GetLCTranslation{cosupervisor}%
						\fi%
					  \scLarge%
						\foreach \name in \uniud@supervisors{%
					  	\par\MakeTextLowercase{\name}%
						}%
					\fi
				}
			\endgroup%
			\vfill%
			% phd cycle and academic year
			\begingroup%
				\IfKeySetByUserT{/uniud/phd cycle}{
					\parbox[t]{\tpbox@width}{%
						\centering\scshape\scnormal%
		        \GetLCTranslation{phdcycle}%
		        \scLarge\par%
		        \MakeTextLowercase{\pgfkeysvalueof{/uniud/phd cycle}}%
					}%
					\IfKeySetByUserT{/uniud/academic year}{\hfill}%
				}%
				\IfKeySetByUserT{/uniud/academic year}{
					\parbox[t]{\tpbox@width}{%
						\centering\scshape\scnormal%
		        \GetLCTranslation{academicyear}%
		        \scLarge\par%
		        \MakeTextLowercase{\pgfkeysvalueof{/uniud/academic year}}%
				}}%
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
 				\IfKeySetByUserT{/uniud/candidate email}{%
	        \pgfkeysvalueof{/uniud/candidate email}%
	        \par\vskip4pt%
				}%
				\IfKeySetByUserT{/uniud/candidate address}{%
          \pgfkeysvalueof{/uniud/candidate address}%
	        \par\vskip4pt%
				}%
        \IfKeySetByUserT{/uniud/inside cover note}{%
          \vskip4pt%
          \pgfkeysvalueof{/uniud/inside cover note}%
	        \par\vskip4pt%
				}%
      \endgroup%
    \end{adjustwidth*}
  \end{titlingpage}
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
%\crefname{listing}{\GetTranslation{listing}}{\GetTranslation{listings}}

% Continuous numbering
\notbool{@countersbychapter}{
  \counterwithout{listing}{chapter}
}{}
}{}}
