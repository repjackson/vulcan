if Meteor.isClient
    Router.route '/internship/:doc_id/view', (->
        @layout 'layout'
        @render 'internship_view'
        ), name:'internship_view'
    Router.route '/internship/:doc_id/edit', (->
        @layout 'layout'
        @render 'internship_edit'
        ), name:'internship_edit'

    Template.internship_view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id
        @autorun => Meteor.subscribe 'model_docs', 'business'
        @autorun => Meteor.subscribe 'model_docs', 'application'
    Template.internship_edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Router.current().params.doc_id


    Template.internship_view.events
        'click .apply': ->
            internship = Docs.findOne Router.current().params.doc_id
            console.log internship
            new_id =
                Docs.insert
                    model:'application'
                    internship_id: Router.current().params.doc_id
                    business_id: internship.business_id
            Router.go "/application/#{new_id}/edit"

    Template.internship_applications.onCreated ->
        @autorun => Meteor.subscribe 'model_docs', 'review'
    Template.internship_applications.helpers
        can_leave_review: ->
            found_review =
                Docs.findOne
                    _author_id:Meteor.userId()
                    model:'review'
                    parent_id:Router.current().params.doc_id
            if found_review then false else true
        reviews: ->
            Docs.find
                model: 'review'
                parent_id:Router.current().params.doc_id
