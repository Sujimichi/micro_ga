#Micro Genetic Algorithm by Jeremy Comer
class MGA
  attr_accessor :population, :generations, :mutation_rate, :cross_over_rate, :fitness_function

  def initialize args = {}
    @popsize = args[:popsize] || 30                   #Number of members (genomes) in the population
    @gene_length = args[:gene_length] || 10           #Number of bit (genes) in a genome
    @cross_over_rate = args[:cross_over_rate] || 0.7  #Prob. of selecting gene from fitter member during recombination
    @mutation_rate = args[:mutation_rate] || 0.1      #Per genome prob. of mutation (see readme)
    @mutation_type = args[:mutation_type] || :decimal
    @generations = args[:generations] || 400          #Number of cycles to perform
    @population = Array.new(@popsize){ Array.new(@gene_length){ 0*rand.round} }   #Initialize population
    @fitness_function = args[:fitness] || Proc.new{|genome| genome.inject{|i,j| i+j} }
  end

  def evolve
    @generations.times do |current_generation|
      #Select two members at random and sort by fitness, select.last => fitter
      select = (0..@popsize-1).sort_by{rand}[0,2].sort_by {|ind| @fitness_function.call(@population[ind]) }      
      @population[select.first] = @population[select.first].zip(@population[select.last]).collect { |genes|
        pos_mutate( genes[ (rand<@cross_over_rate ? 1 : 0) ] ) #Replace % of weaker member's genes with fitter member's with a posibility of mutation.
      } 
    end
  end

  def pos_mutate n
    return n if rand >= @mutation_rate/@gene_length #convert to per gene based muation rate
    @mutation_type.eql?(:decimal) ? (n-1).abs : (n + (rand - 0.5)).round(2) #either binary mutation (1 -> 0, 0 -> 1) or +/- small decimal value.
  end
end
