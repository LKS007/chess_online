class ChessPieces extends React.Component {
  constructor(props) {
    super(props);

    this.state = {whosMove: props.whosMove}

    // this.generateViewForPieceType = this.generateViewForPieceType.bind(this);
    this.renderPiecesOnBoard = this.renderPiecesOnBoard.bind(this)
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    if (prevState.whosMove != nextProps.whosMove) {
      return {
        whosMove: nextProps.whosMove
      }
    }
    return null
  }

  // generateViewForPieceType(piece, steps) {
  //   // console.log(piece['type'])
  //   // let pieceDescription = ""
  //   switch(piece['type']) {
  //     case 'rook':
  //       return <RookPiece key={ piece['id'] }/>
  //     case 'knight':
  //       return <KnightPiece key={ piece['id'] }/>
  //     case 'bishop':
  //       return <BishopPiece key={ piece['id'] }/>
  //     case 'queen':
  //       return <QueenPiece key={ piece['id'] }/>
  //     case 'king':
  //       return <KingPiece key={ piece['id'] }/>
  //     case 'pawn':
  //       return <PawnPiece key={ piece['id'] }/>
  //   }
  //   // console.log(pieceDescription.html())
  //   // return piece['type'] + " "
  //   return <RookPiece key={ piece['id'] }/>
  // }

  renderPiecesOnBoard(pieces_collection, available_steps) {
    let pieces_block = ""
    let changeActiveCell= this.props.changeActiveCell
    let whosMove = this.state.whosMove
    let eatCells = this.props.eatCells
    let canEatSteps = this.props.canEatSteps

    pieces_block = Object.keys(pieces_collection).map(function(objectKey, index) {
      
      // return generateViewForPieceType(
      //   pieces_collection[objectKey], available_steps[objectKey]
      // )
      return <BasicPiece
              key={objectKey}
              piece={pieces_collection[objectKey]}
              steps={available_steps[objectKey]}
              whosMove={whosMove}
              changeActiveCell={changeActiveCell}
              eatCells = {eatCells}
              canEatSteps = {canEatSteps}
              />

    })
    // console.log(pieces_block)
    return pieces_block
  }

  render() {
    renderPieces = this.renderPiecesOnBoard(this.props.pieces_collection, this.props.available_steps)
    return <div id="testpieces">{renderPieces}</div>;
  }
}
