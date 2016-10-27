import Vue from 'vue/dist/vue'
import eventBar from './event_bar'
Vue.component('user-devices', {
  template:
    `<div class='devices'>
      <template v-for="device in devices">
        <h3>{{device.name}}
          <small>
            seen <time class='timeago' v-bind:datetime='device.last_seen_at' >{{device.last_seen_at}}</time>
          </small>
          </h3>
        <event-bar v-bind:device="device" :date="date"></event-bar>
      </template>
    </div>`
  ,
  props: ['user'],
  data:  function () {
    var date = new Date();

    return {
      devices: [],
      date: date
    }
  },
  methods: {
    loadData: function () {
      $.get('/api/users/'+this.user+"/devices", function (response) {
        this.$data.devices = response.data;
      }.bind(this));
    }
  },
  created: function () {
    this.loadData();
  },
  mounted: function () {
    var vm = this;
    $(this.$el).timeago();
  }
})
