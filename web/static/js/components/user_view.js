import Vue from 'vue/dist/vue';
import eventBar from './event_bar';
import moment from 'moment';

Vue.component('user-view', {
  template:
    `<div class='devices'>
      <div class='controls'>
        <button class='btn btn-secondary pull-left' @click="prevDay">Prev</button>
        <button v-show='thereIsTommorow()' class='btn btn-secondary pull-right' @click="nextDay">Next</button>
      </div>
      <span class='date'>{{dayOfWeek()}}</span>
      <template v-for="device in devices">
        <h3>{{device.name}}
          <small>
            seen <time class='timeago' v-bind:datetime='device.last_seen_at' >{{device.last_seen_at}}</time>
          </small>
          </h3>
        <event-bar eventableType="device" :eventable="device" :date="date"></event-bar>
      </template>

      <h3> Slack Presence</h3>
      <event-bar phrase="On Campus" eventableType="user" :eventable="user" :date="date"></event-bar>
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
      $.get('/api/users/'+this.user.id +"/devices", function (response) {
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
      return this.date.format("dddd, MMMM D");
    }
  },
  created: function () {
    this.loadData();
    $(document).keydown(function(e) {
        if(e.which == 37) {
          e.preventDefault();
          this.prevDay();
        }
    }.bind(this));

    $(document).keydown(function(e) {
        if(e.which == 39) {
          e.preventDefault();
          if (this.thereIsTommorow()) {
            this.nextDay();
          }

        }
    }.bind(this));

  },
  mounted: function () {
    var vm = this;
    $('time').timeago();
  }
});
