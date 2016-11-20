import Vue from 'vue/dist/vue';
import eventBar from './event_bar';
import moment from 'moment';

Vue.component('user-devices', {
  template:
    `<div class='devices'>
      <div class='controls'>
        <button class='btn btn-secondary pull-left' @click="prevDay">Prev</button>
        <span>{{dayOfWeek()}}</span>
        <button v-show='thereIsTommorow()' class='btn btn-secondary pull-right' @click="nextDay">Next</button>
      </div>
      <template v-for="device in devices">
        <h3>{{device.name}}
          <small>
            seen <time class='timeago' v-bind:datetime='device.last_seen_at' >{{device.last_seen_at}}</time>
          </small>
          </h3>
        <event-bar :device="device" :date="date"></event-bar>
      </template>
    </div>`,
  props: ['user'],
  data:  function () {
    var date = moment();

    return {
      devices: [],
      date: date
    };
  },
  methods: {
    loadData: function () {
      $.get('/api/users/'+this.user+"/devices", function (response) {
        this.$data.devices = response.data;
      }.bind(this));
    },
    thereIsTommorow: function thereIsTommorow() {
      var numDays = (date) => { return Math.floor(date / 1000 / 60 / 60 / 24);};
      return numDays(this.date) - numDays(new Date());
    },
    nextDay: function nextDay() {
      this.date = moment(this.date).add(1, 'days');
    },
    prevDay: function prevDay() {
      this.date = moment(this.date).add(-1, 'days');
    },
    dayOfWeek: function dayOfWeek() {

      return this.date.format("dddd, MMMM");
    }
  },
  created: function () {
    this.loadData();
  },
  mounted: function () {
    var vm = this;
    $(this.$el).timeago();
  }
});
