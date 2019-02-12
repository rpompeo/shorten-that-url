class Url < ApplicationRecord

    #before_save { self.active = true }
    
    validates_presence_of :target
    validates_presence_of :slug

    def update_slug
        self.active = true
    end
end
