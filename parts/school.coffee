if Meteor.isClient
    Router.route '/school/:doc_id/view', (->
        @layout 'layout'
        @render 'school_view'
        ), name:'school_view'
    Router.route '/school/:doc_id/edit', (->
        @layout 'layout'
        @render 'school_edit'
        ), name:'school_edit'

    Template.school_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'internship'
    Template.school_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        # @autorun => Meteor.subscribe 'model_docs', 'recipe'
    # Template.school_edit.helpers
    #     # 'click .'
    #


    Template.school_view.helpers
        is_fan: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.fan_ids

        is_employee: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.employee_ids

        school_fans: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.fan_ids
            Meteor.users.find
                _id: $in: school.fan_ids


        school_internships: ->
            Docs.find
                model:'internship'
                school_id: Router.current().params.doc_id

    Template.school_view.events
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






    Template.school_edit.helpers
        is_fan: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.fan_ids

        is_employee: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.employee_ids

        school_fans: ->
            school = Docs.findOne Router.current().params.doc_id
            Meteor.userId() and Meteor.userId() in school.fan_ids
            Meteor.users.find
                _id: $in: school.fan_ids

    Template.school_edit.events
        'click .delete_internship': ->
            if confirm 'delete internship?'
                Docs.remove @_id
                Router.go "/school/#{@school_id}/view"
