# The Dockerfile tells Docker how to construct the image with your algorithm.
# Once pushed to a repository, images can be downloaded and executed by the
# network hubs.
FROM custom-r-base

COPY ./requirements.txt /app/requirements.txt

# Change directory to '/app’. This means the subsequent ‘RUN’ steps will
# execute in this directory.
WORKDIR /app

RUN pip3 install -r requirements.txt

# Create two files that will later serve for input/output
RUN touch input.txt
RUN touch output.txt
RUN touch database

COPY dl_coxph.R /app
COPY run_sparql_for_cox.py /app

# Tell docker to execute the script in `WORKDIR` when the image is run.
CMD ["Rscript","dl_coxph.R"]
