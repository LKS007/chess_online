class ChessCell extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      additionalClass: props.additionalClass,
      activeCell: props.activeCell
    }

    this.makeStep = this.makeStep.bind(this);
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    // if (prevState.additionalClass != nextProps.additionalClass) {
    //   return {
    //     additionalClass: nextProps.additionalClass
    //   }
    // }
    if (prevState.activeCell != nextProps.activeCell) {
      return {
        activeCell: nextProps.activeCell,
        additionalClass: nextProps.additionalClass
      }
    }
    return null
  }

  componentDidUpdate(prevProps, prevState, snapshot){
    // if (this.state.additionalClass == 'canEatCell' && this.state.additionalClass != prevState.additionalClass) {
    if (this.state.additionalClass == 'canEatCell' && this.state.activeCell != prevState.activeCell) {
      console.log("Work only one time")
      console.log(this.props)
      prevProps.handleAddEatSteps(this.props.cellId, this.makeStep);
      // console.log(this)
    } 
  }

  makeStep(){
    if (this.props.clickedFigure == undefined) {
      console.log("Some error!!! You need to fix it!")
    }

    //prepare all informations before sending step!

    if (this.state.additionalClass == 'canMoveCell' || this.state.additionalClass == 'canEatCell') {

      let action = this.state.additionalClass == 'canMoveCell' ? 'move' : 'eat'
      
      let stepInfo = {
        from: this.props.clickedFigure.coordinates,
        to: [ this.props.row, this.props.column ],
        action: action
      }

      let makeStepHandler = this.props.makeStepHandler

      $.ajax ({
        method: 'POST',
        url: "/game/make_step",
        data: {
          step: stepInfo,
          user_color: this.props.clickedFigure.color,
          figure: this.props.clickedFigure.type,
          figure_id: this.props.clickedFigure.id,
          game_id: this.props.gameId
        },

        success: function(response) {
          // you need to make sou step

          // you need to change state
          // console.log(this.props)
          makeStepHandler(response)
        }

      })
      // console.log(this.state)
      // console.log(this.props)      
    }
  }

  render() {
    return (      
      <div className={ "chess_cell " + this.props.cellColor + " " + this.state.additionalClass } 
        id={ this.props.cellId } attr-row={ this.props.row } attr-column={ this.props.column } 
        onClick={ this.makeStep }>
      </div>
    );
  }
}
