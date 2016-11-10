import Vue from 'vue/dist/vue';
import moment from 'moment';

Vue.component('attendance', {
  template: `
  <section class='attendance'>
    <div v-if='present()'>
      <small class='text-muted'>
        first seen @ {{arrivedOnCampus()}}
      </small>
      <span>On Campus</span>
      <small class='text-muted'>
        {{leftCampus()}}
      </small>
    </div>
  </section>`,
  props: ['events'],
  methods: {
    eventsOfType: function onlineEvents(type) {
      return this.events.filter(function filterOnlineEvents(event) {
        return event.event_type === type;
      }).sort(function(a,b){
        return b.inserted_at-a.inserted_at;
      });
    },
    arrivedOnCampus: function arrivedOnCampus() {
      let events = this.eventsOfType('online');
      let arrived = moment(events[events.length - 1].started_at);
      return this.fT(arrived);
    },
    leftCampus: function leftCampus() {
      let events = this.eventsOfType('online');
      if (moment(events[0].ended_at).isSameOrAfter(moment().subtract(5, "minutes"))) {
        return "now"
      } else {
        return `left @ ${this.fT(events[0].ended_at)}`;
      }
    },
    fT: function formatTime(time) {
      return moment(time, moment.ISO_8601).format('LT');
    },
    present: function present() {
      return !!this.eventsOfType('online').length;
    }
  }
});
