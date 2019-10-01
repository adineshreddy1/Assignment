var lc = require('./controller.js');

module.exports = function(application){

  application.post('/GenerateToken', function(req, res){
    lc.GenerateToken(req, res);
  });
  application.post('/TransferToken', function(req, res){
    lc.TransferToken(req, res);
  });
  application.post('/GetAllToken', function(req, res){
    lc.GetAllToken(req, res);
  });
  application.get('/QueryName', function(req, res){
    lc.QueryName(req, res);
  });
 
}
