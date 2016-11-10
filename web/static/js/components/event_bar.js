import Vue from 'vue/dist/vue';
import attendance from './attendance';
import moment from 'moment';

Vue.component('event-bar', {
  template: `
  <section>
    <div class='event-bar'>
      <template v-for="event in events">
        <span
          v-bind:title="eventTitle(event)"
          v-bind:data-started_at="event.started_at"
          v-bind:data-ended_at="event.ended_at"
          :class="event.event_type"
          :style="{width:((event.duration_in_minutes / 1440) * 100)+ '%',
            marginLeft:((minutesSinceMidnight(event.started_at) / 1440) * 100) + '%', }"
        >
        </span>
      </template>
    </div>

  <div class='clearfix'></div>
    <attendance :events="events">
  </section>`,
  props: ['device', 'date'],
  data:  function () {
    return {
      events: [],
      total_duration: 0,
    };
  },
  methods: {
    loadData: function () {
      $.get(`/api/devices/${ this.device.id }/events/for/${this.convertDateToQuery(this.date)}`, function (response) {

        var total_duration = response.data.map(function(e) {
          return e.duration_in_minutes;
        }).reduce((a, b) => a + b, 0);

        this.$data.events = response.data.sort(function(a,b){
          return b.inserted_at-a.inserted_at;
        });

        this.$data.total_duration = total_duration;
      }.bind(this));
    },
    convertDateToQuery: function convertDateToQuery(date) {
      return date.format('Y-MM-DDTHH:mm:ss.SSS[Z]Z');
    },
    minutesSinceMidnight: function minutesSinceMidnight(time) {
      let secondsSince = moment(time).unix() - moment(time).startOf('day').unix();
      return secondsSince / 60 ;
    },
    eventTitle: function eventTitle(event) {
      let started_at = moment(event.started_at);
      let ended_at   = moment(event.ended_at);

      return `${started_at.format("LT")} to ${ended_at.format("LT")} for ${ended_at.diff(started_at, "minutes")}`;
    }
  },
  watch: {
    date: function (val, oldVal) {
      this.loadData();
    }
  },
  created: function () {
    this.loadData();
  }
});
