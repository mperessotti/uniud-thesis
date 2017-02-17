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
% \newcommand*\pgfkeys@@notset[1]{
% 	\typeout{DEBUG: C \pgfkeyscurrentpath\space - #1}
% 	\PackageError{pgfkeys}{The '#1' key has not been set to a value.}{}}
% \begingroup
%   \lccode`\Q=`\-
%   \lccode`\N=`\N
%   \lccode`\V=`\V
%   \lowercase{\endgroup
%     \newcommand*\pgfkeys@notset[1]{QNoValue-\pgfkeys@@notset{#1}}}
% \newcommand*\pgfkeys@makeNotSet[1]{
% 	\expandafter\def\csname pgfkeys@notset@#1\endcsname{%
% 		\pgfkeys@notset{#1}%
% 	}}
% \pgfqkeys{/handlers}{%
%   .initial without value/.code/.expand once={%
% 		\pgfkeys@makeNotSet{\pgfkeyscurrentpath}%
% 	  \expandafter\pgfkeyssetvalue\expandafter{\expandafter\pgfkeyscurrentpath\expandafter}\expandafter{\csname pgfkeys@notset@\pgfkeyscurrentpath\endcsname}%
%   },
%   .unset/.code={
%     \pgfkeysifdefined{\pgfkeyscurrentpath}{
% 	    \pgfkeys{\pgfkeyscurrentpath/.initial without value}
% 	  }{
% 		  \PackageError{pgfkeys}{The \pgfkeyscurrentpath\space key has not been initialized.}{}
% 		}
% 	}
% }

\newcommand*\pgfkeys@@notset{\PackageError{pgfkeys}
  {Key not set to a value}{}}
\begingroup
  \lccode`\Q=`\-
  \lccode`\N=`\N
  \lccode`\V=`\V
  \lowercase{\endgroup
    \newcommand*\pgfkeys@notset{QNoValue-\pgfkeys@@notset}}
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
		candidate contacts/.initial without value,
%
		candidate use gender/.is choice,
		candidate use gender/feminine/.code=\booltrue{@candidategenderf},
    candidate use gender/masculine/.code=\boolfalse{@candidategenderf},
%
    supervisor name/.initial without value,
		supervisor contacts/.initial without value,
%
    cosupervisors/.initial={},
		cosupervisor/.style={cosupervisors={#1}},
%
    title/.initial without value,
%
    subtitle/.initial without value,
%
		revision/.initial without value,
%
		date/.initial without value,
%
    academic year/.initial without value,
		phd cycle/.initial without value,
%
		inside cover note/.initial without value,
%
    showframes/.is if=@showframes,
    showframes/.initial=false,
%
		pdfmetadata/.is if=@pdfmetadata,
		pdfmetadata/.initial=true,
%
    counters by chapter/.is if=@countersbychapter,
    counters by chapter/.initial=false,
    countersbychapter/.forward to=/uniud/counters by chapter,
%
		content lists style/.is choice,
		content lists style/.cd,
			compact/.code = {\def\uniud@cftclears{0}},
			single/.code  = {\def\uniud@cftclears{1}},
			double/.code  = {\def\uniud@cftclears{2}},
	/uniud,
		content lists style=compact,
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
		\@CheckRequiredOpt{supervisor name}
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

% Override memoir's document metadata
\renewcommand*\title[1]{
	\uniudset*{title=#1}
}
\renewcommand*\author[1]{
	\uniudset*{candidate name=#1}
}
\renewcommand*\date[1]{
	\uniudset*{date=#1}
}
\newcommand*\thetitle{%
	\IfKeySetByUserT{/uniud/title}{%
		\pgfkeysvalueof{/uniud/title}%
	}}
\newcommand*\theauthor{
	\IfKeySetByUserT{/uniud/candidate name}{%
		\pgfkeysvalueof{/uniud/candidate name}%
	}}
\newcommand*\thedate{%
	\IfKeySetByUserT{/uniud/date}{%
		\pgfkeysvalueof{/uniud/date}%
	}}


% Process class options
\ProcessPgfOptions{/uniud}

% We are based on memoir, so let's load it
\LoadClass[a4paper,11pt]{memoir}

%\setlrmarginsandblock{4cm}{4cm}{*}

% Page Layout
\checkandfixthelayout

\ifbool{@showframes}{%
  \RequirePackage{showframe}%
}{}

\setlength\parskip{0pt}



%
% Fonts
%

%\RequirePackage[
%	light,
%	largesmallcaps,
%	fulloldstylenums,
%]{kpfonts}

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
	letterspace=10
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
% Front and back matter blocks (abstract, acknowledgements)
%

% Some flags associated akin to Memoir's @mainmatter
\@ifundefined{if@frontmatter}{
	\newif\if@frontmatter
	\@frontmatterfalse
	\addtodef{\frontmatter}{}{\@frontmattertrue}
	\addtodef{\mainmatter}{}{\@frontmatterfalse}
}{}
\@ifundefined{if@backmatter}{
	\newif\if@backmatter
	\@backmatterfalse
	\addtodef{\backmatter}{}{\@backmattertrue}
	\addtodef{\appendix}{}{\@backmatterfalse}
}{}

% Dedication page
\newenvironment{dedication}{
	\clearpage
	\ensureonecol
 	\thispagestyle{empty}
 	\par\vspace*{.35\textheight}%
	\centering\small%
}{\cleardoublepage}

\newcommand*{\newfronmatterblock}[2]{
	\@namedef{#1}{%
		\if@frontmatter
			\chapter{#2}
		\else
			\ClassError{Uniud}{Environment '#1' can be used only in the front matter}{}
		\fi}
	\@namedef{#1*}{%
		\if@frontmatter
			\chapter*{#2}
		\else
			\ClassError{Uniud}{Environment '#1' can be used only in the front matter}{}	
		\fi}
	\@namedef{end#1}{\@ifstar{}{}
		\cleardoublepage
	}
}

% Acknowledgements
\newfronmatterblock{acknowledgements}{\GetTranslation{acknowledgements}}
\newfronmatterblock{abstract}{\abstractname}

%
% Content lists (toc, lof, lot, etc.)
%

% Patch content list heads for these are based on chapters
\@ifundefined{uniud@cftclears}{\def\uniud@cftclears{0}}
\newcommand*{\uniud@patchcfthead}[1]{
	% add space between lists
	\@namedef{#1headstart}{%
		\nouppercaseheads
		\if\uniud@cftclears2%
			\cleardoublepage%
		\else%
			\if\uniud@cftclears1%
					\clearpage%
			\else
					\vspace{1.3\afterchapskip}%
			\fi%
		\fi%
	}
	\@namedef{after#1title}{%
		\afterchaptertitle%
		\if\uniud@cftclears2\else%
			\if\uniud@cftclears1\else
					\vspace{-.3\afterchapskip}%
			\fi%
		\fi%
	}
}
\let\memoir@newlistof\newlistof
\renewcommand*{\newlistof}[3]{
	\memoir@newlistof{#1}{#2}{#3}
	\uniud@patchcfthead{#2}
}
% and existing ones
\uniud@patchcfthead{toc}
\uniud@patchcfthead{lof}
\uniud@patchcfthead{lot}

% TOC
\setcounter{tocdepth}{2}
\renewcommand{\cftbookfont}{\normalfont}
\renewcommand{\cftbookpagefont}{\normalfont} 
\renewcommand{\cftpartfont}{\normalfont}
\renewcommand{\cftpartpagefont}{\normalfont} 
\renewcommand{\cftchapterfont}{\normalfont}  
\renewcommand{\cftchapterpagefont}{\normalfont} 

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

\providecommand{\email}[1]{\href{mailto:#1}{#1}}

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

\DeclareTranslationFallback {contacts}{Contacts}
\DeclareTranslation{Italian}{contacts}{Contatti}

\DeclareTranslationFallback {acknowledgements}{Acknowledgements}
\DeclareTranslation{Italian}{acknowledgements}{Ringraziamenti}

%-------------------------------------------------------------------------------
%	COVER
%-------------------------------------------------------------------------------
\RequirePackage{xstring}

\renewcommand\maketitle{%
	\begingroup
  \newlength\@borders
  \setlength\@borders{1cm}
  %\let\oldcleardoublepage\cleardoublepage
  \let\cleardoublepage\clearpage
	\def\scLarge{\fontsize{15pt}{14.4pt}\selectfont}
	\def\scnormal{\fontsize{12.0pt}{11.5pt}\selectfont}
	\def\ncnormal{\fontsize{10.0pt}{12pt}\selectfont}
	\def\ncLarge{\fontsize{12.0pt}{14pt}\selectfont}
  % cover page
  \begin{titlingpage}
		\calccentering{\unitlength}
		\newlength\tpbox@width
		\vspace*{-2cm}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
			\setlength\tpbox@width{\dimexpr.5\textwidth-.5\columnsep}
			\centering
			\IfKeySetByUserT{/uniud/logo}{%
				\newlength\uniud@logo@height%
				\IfKeySetByUserTF{/uniud/logo height}{%
					\setlength\expandafter\pgfkeysvalueof{/uniud/logo height}%
				}{%
					\setlength\uniud@logo@height{2cm}%
				}%
				\edef\uniud@logopath{\pgfkeysvalueof{/uniud/logo}}
				\includegraphics[draft=false,height=\uniud@logo@height]{\uniud@logopath}
				\par\bigskip%
			}
      \begingroup%
        \scshape%
				\scnormal%
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
				\IfKeySetByUserTF{/uniud/phd cycle}{
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/course}},
					\GetLCTranslation{phdcycle}
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/phd cycle}}%
				}{%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/course}}%
				}%
				\par%  
		  \endgroup%
			\vfill%
		  \begingroup%
        \scshape%
				\scnormal%
				\GetLCTranslation{dissertation}
				\bigskip%
				\par%
        \fontsize{32pt}{22pt}\selectfont%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/title}}\par%
				\IfKeySetByUserT{/uniud/subtitle}{%
					\medskip%
					\fontsize{24pt}{20pt}\selectfont%
					\MakeTextLowercase{\pgfkeysvalueof{/uniud/subtitle}}\par%
				}%
      \endgroup%
			\vfill%
			% candidate, supervisor, cosupervisors
			%\par\vspace*{-2cm}%
      \begingroup%
				\parbox[t]{\tpbox@width}{%
				\centering\scshape%
				\scnormal%
				\if@candidategenderf%
					\GetLCTranslation{candidate (f)}%
				\else%
					\GetLCTranslation{candidate (m)}%
				\fi%
				\scLarge\par%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/candidate name}}%
				}\hfill\parbox[t]{\tpbox@width}{%
				\centering\scshape%
				\scnormal%
				\GetLCTranslation{supervisor}%
				\scLarge\par%
				\MakeTextLowercase{\pgfkeysvalueof{/uniud/supervisor name}}%
				\if\pgfkeysvalueof{/uniud/cosupervisors}\empty\else
					\par\bigskip%
					\scnormal%
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
			% \begingroup%
			% 	\IfKeySetByUserT{/uniud/phd cycle}{
			% 		\parbox[t]{\tpbox@width}{%
			% 			\centering\scshape\scnormal%
		  %       \GetLCTranslation{phdcycle}%
		  %       \scLarge\par%
		  %       \MakeTextLowercase{\pgfkeysvalueof{/uniud/phd cycle}}%
			% 		}%
			% 		\IfKeySetByUserT{/uniud/academic year}{\hfill}%
			% 	}%
			\IfKeySetByUserT{/uniud/academic year}{
					\centering\scshape\scnormal%
	        \GetLCTranslation{academicyear}
	        \MakeTextLowercase{\pgfkeysvalueof{/uniud/academic year}}%
			}%
      % \endgroup%
    \end{adjustwidth*}
		\vspace*{-1cm}
  \end{titlingpage}
	% cover's back
	\begin{titlingpage}
    \calccentering{\unitlength}
    \begin{adjustwidth*}{\unitlength-\@borders}{-\unitlength-\@borders}%
      \begingroup%
				\raggedright\normalfont%
				\def\uniud@blockskip{\relax}%
				\newcommand{\uniud@printblock}[2]{%
					\IfKeySetByUserTF{##1}{%
						\uniud@blockskip%
						##2%
						\def\uniud@blockskip{\bigskip}%
					}{\def\uniud@blockskip{\relax}}
				}%
				%
				\uniud@printblock{/uniud/candidate contacts}{%
					\ncLarge\pgfkeysvalueof{/uniud/candidate name}\par%
				  \ncnormal\pgfkeysvalueof{/uniud/candidate contacts}}\par%
				%
				\uniud@printblock{/uniud/supervisor contacts}{%
					\ncLarge\pgfkeysvalueof{/uniud/supervisor name}\par%
				  \ncnormal\pgfkeysvalueof{/uniud/supervisor contacts}}\par%
				%
				\IfKeySetByUserTF{/uniud/revision}{%
					\uniud@blockskip%
					\ncnormal\pgfkeysvalueof{/uniud/revision}%
					\def\uniud@blockmidskip{\xspace-\xspace}%
				}{\def\uniud@blockmidskip{\uniud@blockskip}}
				\IfKeySetByUserTF{/uniud/date}{%
					\uniud@blockmidskip%
					\ncnormal\pgfkeysvalueof{/uniud/date}\par
					\def\uniud@blockskip{\bigskip}%
				}{\def\uniud@blockskip{\par\uniud@blockmidskip}}
				%
				\uniud@printblock{/uniud/inside cover note}{%
          \ncnormal\pgfkeysvalueof{/uniud/inside cover note}}%
      \endgroup%
    \end{adjustwidth*}
  \end{titlingpage}
  % restore \cleardoublepage expected behaviour
  %\let\cleardoublepage\oldcleardoublepage
	\endgroup
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