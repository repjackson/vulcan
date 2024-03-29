if Meteor.isClient
    Router.route '/business/:doc_id/view', (->
        @layout 'layout'
        @render 'business_view'
        ), name:'business_view'
    Router.route '/business/:doc_id/edit', (->
        @layout 'layout'
        @render 'business_edit'
        ), name:'business_edit'

    Template.business_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'internship'
    Template.business_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'recipe'
    # Template.business_edit.helpers
    #     # 'click .'
    #


    Template.business_view.helpers
        is_fan: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.fan_ids

        is_employee: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.employee_ids

        business_fans: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.fan_ids
            Meteor.users.find
                _id: $in: business.fan_ids


        business_internships: ->
            Docs.find
                model:'internship'
                business_id: Router.current().params.doc_id

    Template.business_view.events
        'click .become_fan': ->
            if confirm 'join fan group?'
                Docs.update Router.current().params.doc_id,
                    $addToSet:
                        fan_ids: Meteor.userId()

        'click .remove_fan': ->
            if confirm 'leave fan group?'
                Docs.update Router.current().params.doc_id,
                    $pull:
                        fan_ids: Meteor.userId()






    Template.business_edit.helpers
        is_fan: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.fan_ids

        is_employee: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.employee_ids

        business_fans: ->
            business = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in business.fan_ids
            Meteor.users.find
                _id: $in: business.fan_ids

    Template.business_edit.events
        'click .delete_internship': ->
            if confirm 'delete internship?'
                Docs.remove @_id
                Router.go "/business/#{@business_id}/view"
