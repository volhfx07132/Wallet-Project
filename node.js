return CONTRATC.changeDestination(newAddress, {from: accountDestinnation}).then(function(address){
    CONTRATC.destination().then(function(adminAccount){
        return adminAccount;
    }
})