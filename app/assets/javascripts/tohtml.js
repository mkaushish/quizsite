INIT_PROBLEM = {};
DESTROY_PROBLEM = {};

function initProblem() { 
  //console.log('initProblem');
  for(a in INIT_PROBLEM) {
    //console.log("INIT: " + a);
    INIT_PROBLEM[a].call()
  }
  console.log('Problem JS initialized');
}

function destroyProblem() {
  for(a in DESTROY_PROBLEM) {
    DESTROY_PROBLEM[a].call();
  }
}
