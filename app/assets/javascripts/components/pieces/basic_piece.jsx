class BasicPiece extends React.Component {
  constructor(props) {
    super(props);
    this.state = { clicked: false, whosMove: props.whosMove }
    this.clickHandler = this.clickHandler.bind(this)
    this.eatHandler = this.eatHandler.bind(this)
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    if (prevState.whosMove != nextProps.whosMove) {
      return {
        whosMove: nextProps.whosMove
      }
    }
    return null
  }

  clickHandler() {
    send_value = {}
    cell_id = "cell_" + this.props.piece.coordinates[0] + "_" + this.props.piece.coordinates[1]
    send_value['clicked_id'] = cell_id
    send_value['clicked_figure'] = this.props.piece
    send_value['can_eat_array'] = []
    
    if (this.props.steps != undefined) {
      send_value['can_move'] = this.props.steps.can_move.map(function(step_coord) {
        return "cell_" + step_coord[0] + "_" + step_coord[1]
      })
      send_value['can_eat'] = this.props.steps.can_eat.map(function(eat_coord) {
        send_value['can_eat_array'].push(eat_coord)
        return "cell_" + eat_coord[0] + "_" + eat_coord[1]
      })

      this.props.changeActiveCell(send_value)
    }    
    
  }

  eatHandler() {
    // console.log("EAT HANDLER FOR PIECE")
    let cell_id = "cell_" + this.props.piece.coordinates[0] + "_" + this.props.piece.coordinates[1]
    if (this.props.canEatSteps[cell_id] != undefined) {
      this.props.canEatSteps[cell_id]()
    } else {
      console.log("FUCK! You cant do it")
    }
    // console.log(this.props)
  }

  getPieceImageLink(piece) {
    basePath = "../assets/pieces/"
    return basePath + piece['color'] + "_" + piece['type'] + ".png"
  }

  render() {
    let cell_style = {
      position: 'absolute',
      top: (100 - 12.5 * (this.props.piece.coordinates[0] + 1)) + '%',
      left: 12.5 * this.props.piece.coordinates[1] + '%',
      width: '12.5%',
      height: '12.5%'
    }

    pieceImageLink = this.getPieceImageLink(this.props.piece)
    // console.log(this.state)
    // console.log(this.props)
    
    return (
      <div id={ "figure_" + this.props.piece.id }
        className="cell_with_figure"
        style={ cell_style }
        onClick={this.state.whosMove == this.props.piece.color ? this.clickHandler : this.eatHandler}
      >
        <div className={"piece_div"}>
          <img src={pieceImageLink} draggable="false" width="100%"/>
        </div>
      </div>
    )
  }
}
