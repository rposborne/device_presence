import Vue from 'vue/dist/vue'

Vue.component('event-bar', {
  template: `<div class='event-bar'>
  <template v-for="event in events">
    <div v-bind:class="event.event_type" v-bind:style="{width:((event.duration / total_duration) * 100)+ '%'}"></div>
  </template>
</div>`,
  props: ['device', 'date'],
  data:  function () {
    return {
      events: [],
      total_duration: 0,
    }
  },
  methods: {
    loadData: function () {
      $.get('/api/devices/'+this.device.id+'/events/for/' + this.date, function (response) {

        var total_duration = response.data.map(function(e) {
          return e.duration;
        }).reduce((a, b) => a + b, 0);

        this.$data.events = response.data;
        this.$data.total_duration = total_duration;
      }.bind(this));
    }
  },
  created: function () {
    this.loadData();

    // setInterval(function () {
    //   this.loadData();
    // }.bind(this), 30000);
  }
})
