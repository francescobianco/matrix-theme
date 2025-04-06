
tcols=$(tput cols)
trows=$(tput lines)
chars="01"
space=" "

declare -A matrix
function createMatrix {
  num_rows="$trows"
  num_cols="$tcols"
  for (( i=0; i<=num_rows; i++)) do
    for (( j=0; j<num_cols;j++ )) do
      matrix[$i,$j]=0
    done
  done
}
function setMatrix {
  matrix[$1,$2]=1
}
function unsetMatrix {
  matrix[$1,$2]=0
}
declare -a lines
declare -a linesLength
declare -a linesTail
declare -a linesHead
x=0
y=0

function printBody {
  tl=$1
  hd=$2
  col=$3
  for (( i=tl; i<=hd ; i++ ));do
    setMatrix $i $col
  done
}
function startLine {
  let n=$(( (RANDOM % 100) + 1  ))
  if [[ $n -eq 1 ]];then
    echo 0
  else
    echo 1
  fi
}
function implementMatrix {
  for (( lineNumber=0;lineNumber<tcols ;lineNumber++ ));do
    if [[ ${linesHead[$lineNumber]} -gt ${linesLength[$lineNumber]} ]];then
      let linesTail[$lineNumber]+=1
    fi
    if [[ ${linesTail[$lineNumber]} -eq $trows ]];then
      reInitLine $lineNumber
    fi
    if [[ $(startLine) -eq 0  || ${linesHead[$lineNumber]} -gt 0 ]];then
      let linesHead[$lineNumber]+=1
    fi
    printBody ${linesTail[$lineNumber]} ${linesHead[$lineNumber]} $lineNumber
  done
}
function reInitLine {
  MAXLINELENGTH=$(( tcols / 3))
  lineNumber=$1
  length=$(( $RANDOM % $MAXLINELENGTH ))
  linesLength[$lineNumber]=$length
  linesHead[$lineNumber]=0
  linesTail[$lineNumber]=0

}
function initFirstLines {
  MAXLINELENGTH=$(( tcols / 2 ))
  for ((i=0;i<tcols;i++));do
      length=$(( $RANDOM % $MAXLINELENGTH ))
      linesLength[$i]=$length
      linesHead[$i]=0
      linesTail[$i]=0
  done

}
function initBackgroundColor {
  printf '\e[38;5;070m Foreground color: red\n'
  printf '\e[48;5;0m Background color: black\n'

}
function main {
  initFirstLines
  initBackgroundColor
  for(( ; ; ));do
    createMatrix
    implementMatrix
    draw
  done
}
declare -a grid
function loadFinalGrid {
  gridToPrint="$1"
  tput clear
  printf "%s" "$gridToPrint"
}
function draw {
  grid=
  row=
  for (( current_row=0;current_row<=trows;current_row++ ));do
    row=$(getColumnPaint $current_row)
    grid=$grid"$row"
  done
  loadFinalGrid "$grid"
}
function getColumnPaint {
  row=$1
  numberOfChars=${#chars}
  line=""
  char=""

  GREEN='\033[0;32m'
  #for loop handle column panting
  for (( currColumn=0;currColumn<tcols;currColumn++ ));do
    if [[ ${matrix[$row,$currColumn]} -eq 1  ]];then
      charIndex=$(( RANDOM % $numberOfChars ))
      charIndex=$charIndex
      char=${chars:$charIndex:1}
    else
      char=" "
    fi
    line="${line}${char}"
  done
  echo -n "$line"
}
