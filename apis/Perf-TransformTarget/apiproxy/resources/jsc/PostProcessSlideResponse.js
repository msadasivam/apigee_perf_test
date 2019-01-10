var backendContent = context.getVariable('response.content');
var developerName = context.getVariable('developer.email');
var responseContent = '';

if(backendContent){
    responseContent = JSON.parse(backendContent);
}

if(!responseContent) {
    responseContent = {};
}

responseContent.slideshow.date = new Date();
responseContent.slideshow.title = 'Corporate Slide deck template';
responseContent.slideshow.author = developerName || 'developer';

context.setVariable('response.content', JSON.stringify(responseContent,null,2));