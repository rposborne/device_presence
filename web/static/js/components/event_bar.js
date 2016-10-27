import Vue from 'vue/dist/vue'

Vue.component('event-bar', {
  template: `
  <section>
  <h5>{{date}}</h5>
  <div class='event-bar'>
  <template v-for="event in events">
    <div v-bind:class="event.event_type" v-bind:style="{width:((event.duration / total_duration) * 100)+ '%'}"></div>
  </template>
  </div></section>`,
  props: ['device', 'date'],
  data:  function () {
    function getUTCOffsetString(date) {
      var currentTimezone = date.getTimezoneOffset();
      currentTimezone = (currentTimezone/60);
      var gmt = '';
      if (currentTimezone !== 0) {
        var hour_padding = String(currentTimezone).length === 1 ? '0' : '';
        currentTimezone = currentTimezone * -1
        gmt += currentTimezone > 0 ? '+' : '-';
        gmt += hour_padding
        gmt += Math.abs(currentTimezone);
        gmt += ':00';
      }

      return gmt;
    }

    return {
      events: [],
      total_duration: 0,
      query_date: this.date.toJSON() + getUTCOffsetString(this.date)
    }
  },
  methods: {
    loadData: function () {
      $.get('/api/devices/'+this.device.id+'/events/for/' + this.query_date, function (response) {

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
