// function makeStep(value) {
//   console.log(value)
// }

class ChessField extends React.Component {

  constructor(props) {
    super(props);
    this.generateCells = this.generateCells.bind(this);
    this.handleResize = this.handleResize.bind(this);
    this.handleChangeActiveCell = this.handleChangeActiveCell.bind(this);
    this.makeStepHandler = this.makeStepHandler.bind(this);
    this.handleAddEatSteps = this.handleAddEatSteps.bind(this);

    const boardSize = $('.chess_field__wrapper').width()
    const tileSize = boardSize / 8
    const activeCell = undefined
    const clickedFigure = undefined
    const eatCells = []
    const moveCells = []
    const canEatSteps = []
    const availableSteps = this.props.available_steps
    const whosMove = this.props.whosMove
    const piecesCollection = this.props.pieces_collection
    
    this.state = {boardSize, tileSize, activeCell, eatCells, canEatSteps,
      moveCells, clickedFigure, availableSteps, whosMove, piecesCollection}
  }

  componentDidMount() {
    window.addEventListener("resize", this.handleResize, false);
  }

  componentWillUnmount() {
    window.removeEventListener('resize', this.handleResize)
  }

  handleAddEatSteps(cell_id, makeStep) {
    
    let canEatSteps = this.state.canEatSteps
    canEatSteps[cell_id] = makeStep

    this.setState({
      canEatSteps: canEatSteps
    })
  }

  handleChangeActiveCell(value) {
    console.log(value)    
    
    let activeCell = value['clicked_id']
    let clickedFigure = value['clicked_figure']
    let eatCells = []
    let moveCells = []
    let canEatSteps = []
    if (value['can_eat'] != undefined) {
      eatCells = value['can_eat']      
    }
    if (value['can_move'] != undefined) {
      moveCells = value['can_move']
    }

    this.setState({
      activeCell: activeCell,
      clickedFigure: clickedFigure,
      eatCells: eatCells,
      moveCells: moveCells,
      canEatSteps: canEatSteps
    })
    
  }

  handleResize(size) {
    const boardSize = $('.chess_field__wrapper').width()
    const tileSize = boardSize / 8
    this.setState({boardSize, tileSize})
  }

  generateCells() {
    let chessField = "";
    let current_step = this.props.player_color;
    let rows_count = 0;
    let limit_rows = 7;
    let chessCells = []

    if (current_step == "white") {
      rows_count = 7;
      limit_rows = -1;
    } else {
      rows_count = 0;
      limit_rows = 8;
    }

    while (rows_count != limit_rows) {
      // chessField += "<div class='chess_row'>";
        for (i = 0; i < 8; i++) {
          let cellColor;
          let additionalCellClass = "";
          let cellId = "cell_" + rows_count + "_" + i

          if ( this.state.activeCell == cellId) {
            additionalCellClass = "activeCell"
            // console.log(this.state.activeCell)
            // console.log("Here " + cellId)
          } else if (this.state.moveCells.includes(cellId)) {
            // console.log(this.state.moveCells)
            additionalCellClass = "canMoveCell"
            // console.log("CanMove " + cellId)
          } else if (this.state.eatCells.includes(cellId)) {
            // console.log(this.state.eatCells)
            additionalCellClass = "canEatCell"
          }

          if ((rows_count + i) % 2 == 0) {
            cellColor = "darkCell";
          } else {
            cellColor = "lightCell";
          }

          chessCells.push(
            <ChessCell key={cellId} cellId={cellId} cellColor={cellColor} 
              additionalClass={additionalCellClass} row={rows_count} column={i} gameId={this.props.gameId}
              makeStepHandler={this.makeStepHandler} handleAddEatSteps={this.handleAddEatSteps}
              activeCell={this.state.activeCell} clickedFigure={this.state.clickedFigure}/>
          )
        }
      // chessField += "</div>";

      if (current_step == "white") {
        rows_count -= 1;
      } else {
        rows_count += 1;
      }
    }
    //console.log(chessCells)
    // return {__html: chessField};
    return chessCells
  }

  makeStepHandler(updateInfo) {
    this.setState({
      activeCell: undefined,
      clickedFigure: undefined,
      eatCells: [],
      moveCells: [],
      availableSteps: updateInfo.available_steps,
      whosMove: updateInfo.current_step,
      piecesCollection: updateInfo.pieces_collection
    })
    // console.log("You in makeStep function!!!")
    // console.log("makeStep")
    // console.log(updateInfo)
  }
  
  render() {
    const boardStyles = { position: 'relative', overflow: 'hidden',
      width: '100%', height: this.state.boardSize }
    // pieces = this.props.pieces_collection.map(function(piece, piece_id) {
      // return "a";
      // return piece_id + " HEY! \n ";

    // });
    // console.log(this.props.pieces_collection)
    renderCells = this.generateCells()
    return (
      <div className="chess-field" style={boardStyles}>
        {renderCells}
        <ChessPieces 
          pieces_collection = {this.state.piecesCollection}
          available_steps = {this.state.availableSteps}
          whosMove = {this.state.whosMove}
          eatCells = {this.state.eatCells}
          canEatSteps = {this.state.canEatSteps}
          changeActiveCell = {this.handleChangeActiveCell}
        />
      </div>
    );
  }
}
