$(".toggle").collapse({
  head: "h3,h4,h5",
  group: "div, ul",
  show: function(){
        this.animate({
            opacity: 'toggle',
            height: 'toggle'
        }, 300);
    },
    hide : function() {
        this.animate({
            opacity: 'toggle',
            height: 'toggle'
        }, 300);
    }
  });
