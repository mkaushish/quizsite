function drawMotionGraph(names, nmtype, values) {

  var time = [['2000W01', '2000W02'],
      ['2002Q3', '2002Q4'],
      [1990, 1991],
      [(new Date(2000, 0, 1)), (new Date(2000, 0, 2))]];

  var columnType;
  switch (timeUnits) {
    case 0:
    case 1:
      columnType = 'string';
      break;
    case 2:
      columnType = 'number';
      break;
    case 3:
      columnType = 'date';
      break;
  }
  
  var data = new google.visualization.DataTable();
  for(i=0; i < names.length; i++){
    data.addColumn(nmtypes[i], names[i]);
  }
  for(i=0; i  < values[names[0]].length ; i++){
    arr=[]
    for(j=0; j < names.length; j++){
      arr[j]=values[names[j]][i];
    }
    data.addRow(arr);
  }

  var motionchart = new google.visualization.MotionChart(
      document.getElementById('visualization'));
  motionchart.draw(data, {'width': 800, 'height': 400});
}
var timeUnits = 0;
